module Moneyball
  class Player < ActiveRecord::Base
    has_many :batting_stats, class_name: "Moneyball::BattingStat", foreign_key: "player_id", primary_key: "player_id"

    def full_name
      "#{first_name} #{last_name}"
    end
  end
end
