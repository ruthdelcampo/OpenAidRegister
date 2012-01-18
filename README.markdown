Welcome to Open Aid Register
============================

Open Aid Register www.openaidregister.org is a web application based on ruby on rails 3 that enables NGO users publish their projects in an easy ans smart way. IT dinamically creates IATI XML aid projects.It updates NGO projects in the IATI Registry.


Configure the development environment
-------------------------------------

Open Aid Register uses cartodb as the primary database, you need to go to http://cartodb.com/ and register for an account.

1. Clone the repository and install all the required gems:

        bundle install

2. Copy the sample cartodb_config file and put there your OAUTH or xAuth credentials:

   Log into http://cartodb.com to get your OAUTH or xAuth

        cp config/cartodb_config_example.yml config/cartodb_config.yml

   *OAUTH*

        development:
          host: 'YOUR_CARTODB_DOMAIN'
          oauth_key: 'YOUR_OAUTH_KEY'
          oauth_secret: 'YOUR_OAUTH_SECRET'
          oauth_access_token: 'YOUR_OAUTH_ACCES_TOKEN'
          oauth_access_token_secret: 'YOUR_OAUTH_ACCES_TOKEN_SECRET'

   *xAuth*

        development:
          host: 'YOUR_CARTODB_DOMAIN'
          oauth_key: 'YOUR_OAUTH_KEY'
          oauth_secret: 'YOUR_OAUTH_SECRET'
          username: 'YOUR_CARTODB_USERNAME'
          password: 'YOUR_CARTODB_PASSWORD'

3. Create the database tables:

        bundle exec rake oar:cartodb:create_tables

4. Load the seed data:

        bundle exec rake db:seed

5. You can start the app now:




