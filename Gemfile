source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.1.1'

# Use PG in case you want to deploy to Heroku
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~> 3.1.1'
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

gem 'jquery-rails-cdn'
gem 'jquery-ui-rails-cdn'

#select2 gem needed for CoverMyMeds plugins
gem 'select2-rails'

gem 'carmen-rails'

# cover my meds api gem
gem 'cover_my_meds', '~> 1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '~> 1.3.6', group: :development

gem 'cocoon'

# for paging
gem 'kaminari'
gem 'bootstrap-kaminari-views'

group :development, :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner', :git => 'git://github.com/bmabey/database_cleaner.git'
  gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'pry-rescue'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'selenium-webdriver'
  gem 'pry-rails'
  gem 'rack_session_access'
  gem 'shoulda-matchers'
  gem 'junklet'
end

group :test do
  gem 'webmock'
end
