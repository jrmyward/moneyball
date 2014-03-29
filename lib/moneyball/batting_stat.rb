module Moneyball
  class BattingStat < ActiveRecord::Base
    belongs_to :player, class_name: "Moneyball::Player", foreign_key: "player_id", primary_key: "player_id"
    delegate :first_name, :last_name, :full_name, :birth_year, to: :player, allow_nil: true, prefix: "player"

    scope :for_year, ->(year) { where(year: year) }
    scope :home_run_leader, -> { order("home_runs desc").limit(1) }
    scope :in_league, ->(league) { where(league: league) }
    scope :on_team, ->(team) { where(team_id: team) }
    scope :rbi_leader, -> { order("runs_batted_in desc").limit(1) }

    def self.batting_avg_leader_amongst(players)
      winner = players[0] # assume the first player is the winner to start
      players.each do |player|
        winner = player if player.batting_avg > winner.batting_avg
      end
      return winner
    end

    def self.most_improved_batting_avg(from, to)
      players_start = self.select(:id, :player_id, :hits, :at_bats).for_year(from).where("at_bats >= ?", 200).group("player_id").order("player_id asc")
      players_end   = self.select(:id, :player_id, :hits, :at_bats).for_year(to).where("at_bats >= ?", 200).where(:player_id => players_start.map(&:player_id)).group("player_id").order("player_id asc")
      compare_player_ids = players_end.map(&:player_id)
      year1 = players_start.to_a.keep_if { |p| compare_player_ids.include?(p.player_id) }
      year2 = players_end.to_a
      winner = ""
      delta  = 0
      year1.each_with_index do |player, i|
        player_delta = (year2[i].batting_avg - player.batting_avg).round(6)
        if player_delta > delta
          delta  = player_delta
          winner = player
        end
      end
      "#{winner.player_full_name} (+#{delta})"
    end

    def self.team_slugging_percentage(team_id, year)
      players = self.for_year(year).on_team(team_id)
      team_slugging_percentage = (players.map(&:slugging_percentage).reduce(:+).to_f / players.count).round(3)
    end

    def self.triple_crown_winner(league, year)
      hr_leader  = self.for_year(year).in_league(league).home_run_leader.first
      rbi_leader = self.for_year(year).in_league(league).rbi_leader.first
      return "(No winner)" unless hr_leader.player_id == rbi_leader.player_id

      players = self.for_year(year).in_league(league).where("at_bats >= ?", 400)
      if self.batting_avg_leader_amongst(players).player_id == hr_leader.player_id
        hr_leader.player_full_name
      else
        "(No winner)"
      end
    end

    # Batting average = hits / at-bats
    def batting_avg
      return 0.00 if at_bats == 0
      (hits.to_f / at_bats.to_f).round(3)
    end

    # Slugging percentage = ((Hits – doubles – triples – home runs) + (2 * doubles) + (3 * triples) + (4 * home runs)) / at-bats
    def slugging_percentage
      return 0.00 if at_bats == 0
      ( ( (hits - doubles - triples - home_runs) + (2 * doubles) + (3 * triples) + (4 * home_runs) ).to_f / at_bats.to_f ).round(3)
    end

  end
end
