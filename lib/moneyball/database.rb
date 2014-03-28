module Moneyball
  class Database

    attr_reader :db_env

    def initialize
      @db_env = ENV['DB_ENV'] || "development"
    end

    def connect
      ActiveRecord::Base.establish_connection(
        adapter:  "sqlite3",
        database: "db/#{db_env}.sqlite3"
      )
    end

    def schema_setup
      _create_table_player
      _create_table_batting_stats
    end

    private

    def _create_table_batting_stats
      unless Moneyball::BattingStat.table_exists?
        ActiveRecord::Schema.define do
          create_table :batting_stats, :force => true do |t|
            t.string :player_id
            t.integer :year
            t.string :league
            t.string :team_id
            t.integer :at_bats
            t.integer :hits
            t.integer :doubles
            t.integer :triples
            t.integer :home_runs
            t.integer :runs_batted_in
            t.integer :sb
            t.integer :cs	
          end
        end
      end
    end

    def _create_table_player
      unless Moneyball::Player.table_exists?
        ActiveRecord::Schema.define do
          create_table :players, :force => true do |t|
            t.string :player_id
            t.string :first_name
            t.string :last_name
            t.integer :birth_year
          end
        end
      end
    end


  end

end
