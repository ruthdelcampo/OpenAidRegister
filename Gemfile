source 'http://rubygems.org'

gem 'rails', '3.0.5'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


gem 'cartodb-rb-client', '0.2.0'

gem 'heroku'

#gem 'jquery-rails'



unless $heroku 
	group :development, :test do
	 	gem 'ruby-debug19'
	  	gem "rspec", ">= 2.0.0" 
	   	gem "rspec-rails", ">= 2.0.0"

	   	gem "autotest"
	   	gem 'webrat'
		gem 'heroku'
		gem 'sqlite3'
	end
end


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
