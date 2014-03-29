FactoryGirl.define do
  factory :batting_stat, class: Moneyball::BattingStat do
    player_id     "bartoda02"
    year           2007
    league        "AL"
    team_id       "OAK"
    games          18
    at_bats        72
    r_something    16
    hits           25
    doubles        9
    triples        0
    home_runs      4
    runs_batted_in 8
    sb             1
    cs             0
  end
end
