# Sinatra API

A starting point for creating REST APIs in sinatra.

[![Build Status](https://travis-ci.org/phawk/sinatra-api.svg?branch=master)](https://travis-ci.org/phawk/sinatra-api)

## Includes

* Sinatra + sinatra contrib
* Sequel (default: postgres)
* Warden with basic oauth2 resource owner credentials flow
* Mail (default delivery: postmark)
* sidekiq for background jobs
* RSpec, rack-test, factory_girl and faker

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
# Autorun specs when developing
$ bin/guard
# One off test run
$ bin/rspec
```

#### Setup git pre-push hook

```sh
$ echo "bin/rake ci:all" > .git/hooks/pre-push && chmod +x .git/hooks/pre-push
```

#### Docs on test frameworks

* [RSpec expectations](https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)
* [Mail::TestMailer](https://github.com/mikel/mail#using-mail-with-testing-or-specing-libraries)

### Console

```sh
$ bin/console
```
