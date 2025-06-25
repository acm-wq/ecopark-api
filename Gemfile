source "https://rubygems.org"

gem 'ostruct'
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'bcrypt', '~> 3.1', '>= 3.1.20'

gem 'jwt', '~> 3.1', '>= 3.1.1'
gem 'rack-cors'

gem 'pagy', '~> 9.3', '>= 9.3.4'

gem 'active_model_serializers'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem 'rspec-rails', '~> 8.0.0'
  gem 'rswag', '~> 2.16'
  gem 'faker'
  gem 'factory_bot_rails'
end
