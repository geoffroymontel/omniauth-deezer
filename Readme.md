# OmniAuth Deezer

Deezer API V2 Strategy for OmniAuth 1.0.

Supports the OAuth-like Deezer API V2 server-side flow. Read the Deezer docs for more details: http://www.deezer.com/en/developers/simpleapi/oauth

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-deezer'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::Deezer` is a plugin to OmniAuth 1.0. See Omniauth docs for more information : https://github.com/intridea/omniauth.

Add to your `Gemfile`:

```ruby
gem 'omniauth-facebook'
```

Then run `bundle install`.

Create an app on Deezer website and save your app id and app secret.

In your Rack application, for instance in your Rails application, add the following lines in `config/initializers/omniauth.rb`and use your app id and secret.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :deezer, ENV['DEEZER_APP_ID'], ENV['DEEZER_APP_SECRET'], :perms => 'basic_access,email'
end
```

Like omniauth-facebook, if you get the following error when redirected back from Deezer :

````bash
OpenSSL::SSL::SSLError (SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed)
````

You need to point your app to your SSL certificates directory :

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :deezer, ENV['DEEZER_APP_ID'], ENV['DEEZER_APP_SECRET'], :perms => 'basic_access,email', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end
```

Then change your routes in your application `config/routes.rb`

```ruby
OmniauthTest::Application.routes.draw do
  match 'auth/deezer/callback' => 'sessions#create'
  match 'auth/failure' => 'errors#login_failed'
end
```

Then start your app and point your browser to /auth/deezer

## Configuring

You can only configure :

* `perms`: A comma-separated list of permissions you want to request from the user. See the Deezer docs for a full list of available permissions: http://www.deezer.com/en/developers/simpleapi/oauth. 
Default: `basic_access`

## Authentication Hash

Here's an example *Authentication Hash* available in `request.env['omniauth.auth']`:

```ruby
---
provider: deezer
uid: '999999'
info:
  name: John Smith
  nickname: jsmith
  last_name: John
  first_name: Smith
  location: FR
  image: http://api.deezer.com/2.0/user/999999/image
  urls:
    Deezer: http://www.deezer.com/profile/999999
  email: john.smith@example.com
credentials:
  token: 0xAOhmGc74f33d7f3e24567wSPwGIvI4f33d7f3e219am8n1xho
  expires: 'true'
  expires_at: 3600
extra:
  raw_info:
    id: '304418'
    name: jsmith
    lastname: Smith
    firstname: John
    email: john.smith@example.com
    birthday: '1975-01-01'
    inscription_date: '2007-02-01'
    gender: M
    link: http://www.deezer.com/profile/999999
    picture: http://api.deezer.com/2.0/user/999999/image
    country: FR
    type: user
```

The precise information available may depend on the permissions which you request.

## Sample app

You can find a sample app that use this GEM here :
https://github.com/geoffroymontel/omniauth-deezer-test

## Tests

This first version does not have any automated test. I'm really sorry.
But you're really welcome to help me add any !

## Contributing

This is my first GEM, so don't hesitate to raise bugs, fork, and submit bug fixes and automated tests!

## License

Copyright 2012 by [Geoffroy Montel](https://github.com/geoffroymontel)
Contributions from [Jacek Tomaszewski](https://github.com/jtomaszewski) and [Simone Dall'Angelo](https://github.com/simo2409)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
