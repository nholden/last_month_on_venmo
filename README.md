# Last Month on Venmo
A command line application that returns information about your last 30 days of Venmo payments.

## Getting started
```
git clone git://github.com/nholden/last_month_on_venmo.git
cd last_month_on_venmo
ruby last_month_on_venmo.rb
```

## Obtaining your Venmo access token
Go [here](https://api.venmo.com/v1/oauth/authorize?client_id=1494&response_type=token&scope=access_feed,access_profile,access_email,access_phone,access_friends,make_payments,write_apps,access_webhooks,write_webhooks&state=/?), enter your Venmo credentials, and click "Allow." Copy the "access_token" parameter from the URL. The token will be valid for the next 30 minutes.

## Obtaining another person's Venmo username
Log in to [Venmo.com](http://venmo.com). Type the name of the person you would like to find in the "Search people" box. The person's Venmo username will appear above his or her name.

## Credits
This project was created by Nick Holden and is licensed under the terms of the MIT license.
