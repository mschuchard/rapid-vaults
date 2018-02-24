require_relative 'rapid-vaults/decrypt'
require_relative 'rapid-vaults/encrypt'
require_relative 'rapid-vaults/generate'

# interfaces from cli/api, validates settings, and then distributes actions to appropriate classes
class RapidVaults
  # initialize settings hash
  @settings = {}

  # allow cli and api read/write access to settings with self since this is singleton
  class << self
    attr_accessor :settings
  end

  # main runner for software
  def main
    # short circuit if we are generating
    return Generate.main(self.class.settings) if self.class.settings[:action] == :generate

    # process settings
    self.class.process

    # execute desired action via dynamic call
    # public_send("#{self.class.settings[:action].capitalize}.main".to_sym)
    case self.class.settings[:action]
    when :encrypt then Encrypt.main(self.class.settings)
    when :decrypt then Decrypt.main(self.class.settings)
    end
  end

  # method for processing the settings and inputs
  def self.process
    # check for problems with arguments
    case @settings[:action]
    when :encrypt
      raise 'File, key, and nonce arguments are required for encryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce)
    when :decrypt
      raise 'File, key, nonce, and tag arguments are required for decryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce) && @settings.key?(:tag)
    else
      raise 'Action must be one of generate, encrypt, or decrypt.'
    end

    # check for problems with inputs and read in files
    raise 'Password must be a string.' if @settings.key?(:pw) && !settings[:pw].is_a?(String)
    File.file?(@settings[:file]) ? @settings[:file] = File.read(@settings[:file]) : (raise 'Input file is not an existing file.')
    File.file?(@settings[:key]) ? @settings[:key] = File.read(@settings[:key]) : (raise 'Input key is not an existing file.')
    File.file?(@settings[:nonce]) ? @settings[:nonce] = File.read(@settings[:nonce]) : (raise 'Input nonce is not an existing file.')
    return unless @settings[:action] == :decrypt
    File.file?(@settings[:tag]) ? @settings[:tag] = File.read(@settings[:tag]) : (raise 'Input tag is not an existing file.')
  end
end
