class RapidVaults::API
  # lightweight api
  def self.api(settings)
    # establish settings and denote using api
    @settings = settings
    @settings[:ui] = :api

    # process settings
    process

    # execute desired action
    public_send(@settings[:action])
  end
end
