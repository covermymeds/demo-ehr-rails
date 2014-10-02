# CoverMyApi

cover_my_api is a gem that provides a Ruby client for api.covermymeds.com

## Installation

Add this line to your application's Gemfile:

    gem 'cover_my_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cover_my_api

## Developing
 - Run the tests
 - Make a branch, add your features
 - Merge master into your branch
 - Run the tests
 - Do a pull request
 - After review, merge your branch into master
 - Increment the version number in: `lib/cover_my_api/version.rb`
 - `git add lib/cover_my_api/version.rb && git commit`
 - `git tag v<your version>`
 - `git push origin master && git push --tags`
 - `rake release` (sends it to our local gem server)

## Usage

You can use the CoverMyApi client to retrieve drugs, forms, pa requests, access tokens and create requests.

    require 'cover_my_api'

## Getting Started

Before anything else, create a new client:

    client = CoverMyApi::Client.new({api_id: 'ahhbrzs4a0q1om3y7nwn', api_secret: 'kkihcug797zu4bzomnh-sbamgqpxyr5yf2pvvqzm'})
    
## Drug Search

    drugs = client.drug_search 'Boniva'
    
    drugs # array of drugs
    drug = drug.first
    drug.name # 'Boniva'
    
For complete list of response properties go to [Drugs]( https://api.covermymeds.com/#drugs)
 
 
## Form Search

    forms = client.form_search('Blue Cross', drug.id, 'oh')
    
    forms # array of forms
    form = form.first
    form.name # 'blue_cross_blue_shield_georgia_general'
    
For complete list of response properties go to [Forms]( https://api.covermymeds.com/#forms)

## Get Request(s)

    #Get a single request
    request = client.get_request(token_id)
    
    request.id # 'NT5HL9'
    
    #Get many requests
    requests = client.get_requests([token_id1, token_id2])
    requests # array of requests
    
For complete list of response properties go to [Requests]( https://api.covermymeds.com/#requests)

    
## Create Request

    new_request = client.request_data
    request_data.patient.first_name = 'John'

For complete list of response properties go to [Requests]( https://api.covermymeds.com/#requests)

    request = client.create_request new_request
    request.patient.first_name # 'Jonhn'

For complete list of response properties go to [Requests]( https://api.covermymeds.com/#requests)
  
  
## Create access tokens

    token = client.create_access_token('DS3SE1')
    token.id # 'nhe44fu4g22upqqgstea'
    
For complete list of response properties go to [Tokens]( https://api.covermymeds.com/#requeststokens)
 
## Revoke access tokens

    client.revoke_access_token?('DS3SE1') # true

[Api documentation on Revoking Token Access]( https://api.covermymeds.com/#deleting-a-request)
 
