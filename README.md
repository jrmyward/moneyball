# Moneyball

Moneyball is an MVP (no pun intend...well, only a little intended) command line application
for retrieving random baseball stats.

## Installation

This application is not intended to be an "official" ruby gem. Therefore, to install it, you
simply need to clone the repository:

    $ git clone git@github.com:jrmyward/moneyball.git


Next, you need to bundle the dependencies:

    $ cd moneyball
    $ bundle

Finally, to view the available commands:

    $ bundle exec moneyball --help

## Usage

Moneyball has several available commands.

### Highlights

To see some interesting, if not random, stats, run:

    $ bundle exec moneyball highlights

View, the available options to change the output:

    $ bundle exec moneyball highlights --help

There are three more commands. Feel free to explore them at your leisure.

## Specs

To run the specs, you have two options.

First, with Guard:

    $ bundle exec guard
     // tap Enter to have guard run the entire test suite  

Second, good-ol RSpec, with a twist

    $ DB_ENV=test bundle exec rspec

`DB_ENV=test` simply signals ActiveRecord that you want to use the Test database.

## TODO
* Add error handling to command inputs
* Add additional test coverage to Class-level methods.

## CSV Assumptions
### Batting-07-12.csv
* G = games
* R = ?
* SB = ?
* CS = ?

## Contributing

1. Fork it ( http://github.com/<my-github-username>/moneyball/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
