# Sinatra API

A starting point for creating REST APIs in sinatra.

[![Build Status](https://travis-ci.org/phawk/sinatra-api.svg?branch=master)](https://travis-ci.org/phawk/sinatra-api)

## Includes

* Sinatra + sinatra contrib
* ActiveRecord (default: postgres)
* Warden with basic JWT token auth
* Mail (default delivery: postmark)
* sidekiq for background jobs
* RSpec, rack-test, factory_bot and faker

## Getting started

### Configuration

```sh
# Copy the configuration environment variables
$ cp .env.example .env

# Edit the env vars
$ vim .env

# Create dev + test databases
$ bin/rake db:create

# Run initial migrations
$ bin/rake db:migrate
$ bin/rake db:migrate APP_ENV=test
```

### Running

```sh
$ bin/shotgun
$ open http://localhost:9393
```

### Testing

```sh
$ bin/rspec
```

#### Setup git hooks

```sh
$ echo "bin/rake ci:all" > .git/hooks/pre-push && chmod +x .git/hooks/pre-push
$ echo "bin/rubocop" > .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
```

#### Docs on test frameworks

* [RSpec expectations](https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)
* [Mail::TestMailer](https://github.com/mikel/mail#using-mail-with-testing-or-specing-libraries)

### Console

```sh
$ bin/console
```
