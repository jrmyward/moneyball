module Moneyball
  class BattingStat < ActiveRecord::Base
    belongs_to :player, class_name: "Moneyball::Player", foreign_key: "player_id", primary_key: "player_id"
    delegate :first_name, :last_name, :full_name, :birth_year, to: :player, allow_nil: true, prefix: "player"

    scope :for_team, ->(team) { where(team_id: team) }
    scope :for_year, ->(year) { where(year: year) }
    scope :home_run_leader, -> { order("home_runs desc").limit(1) }
    scope :in_league, ->(league) { where(league: league) }
    scope :rbi_leader, -> { order("runs_batted_in desc").limit(1) }

    def self.batting_avg_leader_amongst(players)
      winner = players[0] # assume the first player is the winner to start
      players.each do |player|
        winner = player if player.batting_avg > winner.batting_avg
      end
      return winner
    end

    def self.team_slugging_percentage(team_id, year)
      players = season_roster(team_id, year)
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
