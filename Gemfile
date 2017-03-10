source 'https://rubygems.org'

ruby '~> 2.2.6'

gem 'rails', '4.2.7.1'

# Use PG in case you want to deploy to Heroku
gem 'pg'

gem 'sass-rails', '>= 3.2'

# Use SCSS for stylesheets
gem 'bootstrap-sass', '>= 3.3.6'
gem 'bootstrap-datepicker-rails'

gem 'rest-client'

# for heroku
gem 'rails_12factor', group: :production
gem 'puma'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'carmen-rails'

# cover my meds api gem
gem 'cover_my_meds', '>= 1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '~> 1.3.6', group: :development

# for paging
gem 'kaminari'
gem 'bootstrap-kaminari-views'

# for nested forms
gem 'cocoon'

gem 'dotenv-rails'

group :development, :test do 
  # run with the thin web server
  gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
  gem 'rb-readline'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'selenium-webdriver', '~> 2.0'
  gem 'rack_session_access'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'rspec-junklet'
  gem 'webmock'
end
