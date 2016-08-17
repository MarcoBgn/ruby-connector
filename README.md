# connector-basecrm
-------------------------------------
[![Code Climate](https://codeclimate.com/github/maestrano/connector-basecrm/badges/gpa.svg)](https://codeclimate.com/github/maestrano/connector-basecrm)
-------------------------------------
The aim of this connector is to implement data sharing between Connec! and BaseCRM

### Configuration

Configure your BaseCRM application. To create a new BaseCRM application:
https://app.futuresimple.com

Create a configuration file `config/application.yml` with the following settings (complete with your BaseCRM / Connec! credentials)
```
connec_api_id:
connec_api_key:
base_client_id:
base_client_secret:
```
### Run the connector
#### First time setup
```

# Install JRuby and gems the first time, install redis-server
rvm or rbenv install jruby-9.0.5.0
gem install bundler
bundle
gem install foreman
```

Visit: http://redis.io/download to download and install redis

#### Start the application
In two different terminal windows run:
```
redis-server
foreman start
```

### Run the connector locally against the Maestrano production environment
Add in the application.yml file the following properties:
```
api_host: 'http://localhost:3000'
connec_host: 'http://localhost:8080'
```

### Test webhooks
Install [ngrok](https://ngrok.com)
Start in on your application port (for example 3000)
```
ngrok http 3000
```
this will open a console with an url that is tunnelling to your localhost (for example https://aee0c964.ngrok.io)
update the `app_host` in the application.yml and the redirect_url in base_client.rb
```
app_host: 'https://aee0c964.ngrok.
```
then edit your app settings in BaseCRM

Login into your base account
Go to `settings`
Open `Oauth` tab
Modify your developer app settings

### Update application metadata

Login into your Maestrano Account.
Access the API tab.
Select the Sandbox-BaseCRM1 tab.
update the field `Metadata URL` with

```
{{your ngrok tunnel or website }}/maestrano/metadata

```

Click on `Update/Fetch`
