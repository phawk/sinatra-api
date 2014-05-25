# Sinatra API

A simple starting point for creating REST APIs in sinatra.

## Includes

* Sinatra + sinatra contrib
* ActiveRecord (default: postgres)
* Warden with basic oauth2 resource owner credentials flow
* Mail (default delivery: postmark)
* Minitest::Spec with mocha, rack-test, factory_girl and faker

## Getting started

### Boot up vagrant

```sh
$ vagrant up
$ vagrant ssh
```

### Configuration

```sh
# Copy the configuration environment variables
$ cp .env.example .env

# Edit the env vars
$ vim .env
```

### Running

```sh
$ foreman start
$ open http://localhost:5050
```

### Testing

```sh
$ rake spec
$ rake spec:fast
$ rake spec:units
$ rake spec:stories
```

#### Docs on test frameworks

* [Minitest expectations](http://bfts.rubyforge.org/minitest/MiniTest/Expectations.html#method-i-must_include)
* [Mocha](http://gofreerange.com/mocha/docs/)
* [Mail::TestMailer](https://github.com/mikel/mail#using-mail-with-testing-or-specing-libraries)

### Console

```sh
$ rake irb
```
