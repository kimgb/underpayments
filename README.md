## UNDERPAID

This Rails application, bespoke for the purposes of calculating Australian underpayments claims, was developed with Ruby 2.2.3, Rails 4.2.4, and rbenv 0.4.0. It's since been upgraded to Ruby 2.3, Rails 4.2.5.1. It uses a PostgreSQL database (9.3 and later 9.5 during development). You will be able to specify the Postgres user and password using Figaro and the `config/application.yml` file, but as this application uses Postgres' `hstore` feature that user will need superuser in addition to the usual createdb powers.


### SETUP

#### RUBY

For rbenv users, if you currently lack a Ruby 2.3.0 package, first make sure your `ruby-build` is up to date with `cd ~/.rbenv/plugins/ruby-build` and `git pull`. Then you should be able to run `rbenv install 2.3.0` without any problems.

You can try changing the version specified in `.ruby-version`. The project was first developed with 2.2.3, but I ran the upgrade to 2.3 and that did involve some Gemfile tweaking (had to switch to the Sass version of Bootstrap, for instance). Safest to roll with 2.3.

RVM users, as of writing, you're on your own.

#### GEMS

A `bundle install` should get you up and running, probably followed by an `rbenv rehash`: I've tried to keep the Gemfile quite explicit.

#### ENV VARS

I'm using the Figaro gem to set environment variables in `config/application.yml`. There is a committed example file, `config/application.example.yml` to show you what env vars the application will expect to be set.

#### DATABASE

As shipped, it's using a PostgreSQL database with hstore enabled. During development, I found my db user required superuser in order to enable the hstore extension. CreateDB alone didn't cut it. Once your db user is set up (see also: env vars, above), a simple `rake db:setup` should get you going. Check out `db/seeds.rb` to find your initial admin account credentials.

#### EMAIL

As is, the application uses Mailgun for transactional emails. If you prefer a different provider, you'll need to modify the appropriate files.


### TESTS

Patchy at best, but I've tried to keep controller test coverage high: this makes it easier for me to find the big application breaking bugs. Some model testing is present. It's a work in progress.


### SERVICES

None as of writing.


### DEPLOYMENT

Deployment with Capistrano. WIP
