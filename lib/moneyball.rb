require "active_record"
require 'moneyball/batting_stat'
require 'moneyball/database'
require 'moneyball/player'
require 'moneyball/version'
require 'pry'

db = Moneyball::Database.new
db.connect

module Moneyball

  class Stats
    def say_hello
      puts "Moneyball is alive and well."
    end
  end

end
