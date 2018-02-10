class RapidVaults::API
  # lightweight api
  def self.main(settings)
    # establish settings and denote using api
    RapidVaults.settings = settings
    RapidVaults.settings[:ui] = :api

    # run RapidVaults with specified file
    RapidVaults.new.main
  end
end
