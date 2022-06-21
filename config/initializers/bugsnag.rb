#frozen_string_literal: true

#Bugsnag for all environments except localhost
if Rails.env.production?
  Bugsnag.configure do |config|
    config.api_key = "6b758edc3597ab20156d19c36815c0ce"
  end
end
