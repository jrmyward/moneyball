module Moneyball
  class BattingStat < ActiveRecord::Base
    belongs_to :player, class_name: "Moneyball::Player", foreign_key: "player_id", primary_key: "player_id"
    delegate :first_name, :last_name, :full_name, :birth_year, to: :player, allow_nil: true, prefix: "player"

    def self.season_roster(team_id, year)
      where(team_id: team_id).where(year: year)
    end

    def self.team_slugging_percentage(team_id, year)
      players = season_roster(team_id, year)
      binding.pry
      team_slugging_percentage = (players.map(&:slugging_percentage).reduce(:+).to_f / players.count).round(3)
      # "Slugging Percentage for #{team_id} in #{year}: #{team_slugging_percentage}"
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
