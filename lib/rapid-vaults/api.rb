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
    # validate args
    if %i[encrypt decrypt].include?(settings[:action])
      raise 'no file specified for encryption or decryption' if !settings.key?(:file)
    end

    raise 'input password cannot be empty' if settings.key?(:pw) && settings[:pw].empty?

    # establish settings for api and denote using api
    settings.merge({ ui: :api })
  end
end
