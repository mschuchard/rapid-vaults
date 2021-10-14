require_relative '../rapid_vaults'

# provides an application programming interface to interact with rapid vaults
class RapidVaults::API
  # lightweight api
  def self.main(settings)
    # parse pass-by-value settings for api and run RapidVaults with specified settings
    RapidVaults.new.main(parse(settings))
  end

  # parse api options; this is mostly here for unit testing
  def self.parse(settings)
    # establish settings for api and denote using api
    settings[:ui] = :api
    settings
  end
end
