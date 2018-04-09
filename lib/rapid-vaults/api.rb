require_relative '../rapid-vaults'

# provides an application programming interface to interact with rapid vaults
class RapidVaults::API
  # lightweight api
  def self.main(settings)
    # parse settings in api and denote using api
    RapidVaults.settings = parse(settings)

    # run RapidVaults with specified file
    RapidVaults.new.main
  end

  # parse api options
  def self.parse(settings)
    # establish settings for api
    settings[:ui] = :api
    settings[:algorithm] = :openssl
    settings
  end
end
