source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'excon', '~> 0.92.3' # make http-request
gem 'pg', '~> 1.1' # postgresql interface
gem 'puma', '~> 5.0' # http-server
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'awesome_print', '~> 1.9' # beautiful print objects
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw] # for debug
  gem 'dotenv-rails', '~> 2.7' # autoload .env
  gem 'pry-byebug', '~> 3.9' # for debug
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 1.28' # linting
  gem 'rubocop-rails', '~> 2.14' # linting
  gem 'rubocop-rspec', '~> 2.10' # linting
  gem 'spring'
end

group :test do
  gem 'rspec', '~> 3.11'
  gem 'rspec-rails', '~> 5.1'
  gem 'webmock', '~> 3.14' # mock http requests
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
