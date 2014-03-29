require 'csv'

module Moneyball
  class Database

    attr_reader :db_env

    def initialize
      @db_env = ENV['DB_ENV'] || "development"
    end

    def bootstrap
      puts "Loading schema..."
      schema_setup
      seed_data if db_env == 'development'
    end

    def connect
      ActiveRecord::Base.establish_connection(
        adapter:  "sqlite3",
        database: "db/#{db_env}.sqlite3"
      )
    end

    def seed_data
      _seed_players
      _seed_batting_stats
    end

    def schema_setup
      _create_table_player
      _create_table_batting_stats
    end

    private

    def _create_table_batting_stats
      unless Moneyball::BattingStat.table_exists?
        puts "Creating batting_stats"
        ActiveRecord::Schema.define do
          create_table :batting_stats, :force => true do |t|
            t.string :player_id
            t.integer :year
            t.string :league
            t.string :team_id
            t.integer :games
            t.integer :at_bats
            t.integer :r_something
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
        puts "Creating players"
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

    def _seed_batting_stats
      Moneyball::BattingStat.delete_all
      puts "Importing batting_stats"
      CSV.foreach('db/Batting-07-12.csv', headers: true) do |row|
        Moneyball::BattingStat.create! do |stats|
          stats.player_id      = row[0].blank? ? "" : row[0]
          stats.year           = row[1].blank? ? 0 : row[1]
          stats.league         = row[2].blank? ? "" : row[2]
          stats.team_id        = row[3].blank? ? "" : row[3]
          stats.games          = row[4].blank? ? 0 : row[4]
          stats.at_bats        = row[5].blank? ? 0 : row[5]
          stats.r_something    = row[6].blank? ? 0 : row[6]
          stats.hits           = row[7].blank? ? 0 : row[7]
          stats.doubles        = row[8].blank? ? 0 : row[8]
          stats.triples        = row[9].blank? ? 0 : row[9]
          stats.home_runs      = row[10].blank? ? 0 : row[10]
          stats.runs_batted_in = row[11].blank? ? 0 : row[11]
          stats.sb             = row[12].blank? ? 0 : row[12]
          stats.cs             = row[13].blank? ? 0 : row[13]
        end
      end
    end

    def _seed_players
      Moneyball::Player.delete_all
      puts "Importing players"
      CSV.foreach('db/Master-small.csv', headers: true) do |row|
        Moneyball::Player.create! do |player|
          player.player_id   = row[0].blank? ? "" : row[0]
          player.first_name  = row[2].blank? ? "" : row[2]
          player.last_name   = row[3].blank? ? "" : row[3]
          player.birth_year  = row[1].blank? ? 0000 : row[1]
        end
      end
    end

  end

end
