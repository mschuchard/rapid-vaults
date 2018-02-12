require 'openssl'
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
    # process settings
    self.class.process

    # execute desired action via dynamic call
    public_send("#{@settings[:action].capitalize}.main".to_sym)
  end

  # method for processing the settings and inputs
  def self.process
    # check for problems with arguments
    if @settings[:action] == :encrypt
      raise 'File, key, and nonce arguments are required for encryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce)
    elsif @settings[:action] == :decrypt
      raise 'File, key, nonce, and tag arguments are required for decryption.' unless @settings.key?(:file) && @settings.key?(:key) && @settings.key?(:nonce) && @settings.key?(:tag)
    elsif @settings[:action] != :generate
      raise 'Action must be one of generate, encrypt, or decrypt.'
    end

    # check for problems with inputs and read in files
    File.file?(@settings[:file]) ? @settings[:file] = File.read(@settings[:file]) : (raise 'Input file is not an existing file.')
    File.file?(@settings[:key]) ? @settings[:key] = File.read(@settings[:key]) : (raise 'Input key is not an existing file.')
    File.file?(@settings[:nonce]) ? @settings[:nonce] = File.read(@settings[:nonce]) : (raise 'Input nonce is not an existing file.')
    return unless @settings[:action] == :decrypt
    File.file?(@settings[:tag]) ? @settings[:tag] = File.read(@settings[:tag]) : (raise 'Input tag is not an existing file.')
  end
end
