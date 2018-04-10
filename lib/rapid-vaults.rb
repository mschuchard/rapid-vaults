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
    return Generate.main(self.class.settings) if self.class.settings[:action] == :generate && self.class.settings[:algorithm] == :openssl

    # process settings
    self.class.process

    # execute desired action and algorithm via dynamic call
    # public_send("#{self.class.settings[:action].capitalize}.#{self.class.settings[:algorithm]}".to_sym)
    case self.class.settings[:action]
    when :encrypt then Encrypt.public_send(self.class.settings[:algorithm], self.class.settings)
    when :decrypt then Decrypt.public_send(self.class.settings[:algorithm], self.class.settings)
    end
  end

  # method for processing the settings and inputs
  def self.process
    # check for problems with arguments
    if @settings[:algorithm] == :gpgme
      raise 'GPG key generation is currently not supported.' if @settings[:action] == :generate
      raise 'Action must be encrypt or decrypt.' unless @settings[:action] == :encrypt || @settings[:action] == :decrypt
      raise 'File and GPG key argument required for encryption or decryption.' unless @settings.key?(:file) && @settings.key?(:key)
    else
      case @settings[:action]
      when :encrypt
        raise 'File, key, and nonce arguments are required for encryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce)
      when :decrypt
        raise 'File, key, nonce, and tag arguments are required for decryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce) && @settings.key?(:tag)
      else
        raise 'Action must be one of generate, encrypt, or decrypt.'
      end
    end

    # check for problems with inputs and read in files
    raise 'Password must be a string.' if @settings.key?(:pw) && !settings[:pw].is_a?(String)
    File.file?(@settings[:file]) ? @settings[:file] = File.read(@settings[:file]) : (raise 'Input file is not an existing file.')
    File.file?(@settings[:key]) ? @settings[:key] = File.read(@settings[:key]) : (raise 'Input key is not an existing file.')
    # gnugp only uses key and file
    return if @settings[:algorithm] == :gpgme
    File.file?(@settings[:nonce]) ? @settings[:nonce] = File.read(@settings[:nonce]) : (raise 'Input nonce is not an existing file.')
    # only decrypt needs a tag input
    return unless @settings[:action] == :decrypt
    File.file?(@settings[:tag]) ? @settings[:tag] = File.read(@settings[:tag]) : (raise 'Input tag is not an existing file.')
  end
end
