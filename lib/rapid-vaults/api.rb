require_relative '../rapid-vaults'

# provides an application programming interface to interact with rapid vaults
class RapidVaults::API
  # lightweight api
  def self.main(settings)
    # parse settings for api and run RapidVaults with specified settings
    RapidVaults.new.main(parse(settings))
  end

  # parse api options
  def self.parse(settings)
    # establish settings for api and denote using api
    settings[:ui] = :api
    settings[:algorithm] = :openssl unless settings.key?(:algorithm)
    settings
  end
end
