require_relative 'rapid-vaults/decrypt'
require_relative 'rapid-vaults/encrypt'
require_relative 'rapid-vaults/generate'

# interfaces from cli/api, validates settings, and then distributes actions to appropriate classes
class RapidVaults
  # main runner for software
  def main(settings)
    # process settings
    self.class.process(settings)

    # execute desired action and algorithm via dynamic call
    # public_send("#{settings[:action].capitalize}.#{settings[:algorithm]}".to_sym, settings)
    case settings[:action]
    when :generate then Generate.public_send(settings[:algorithm], settings)
    when :encrypt then Encrypt.public_send(settings[:algorithm], settings)
    when :decrypt then Decrypt.public_send(settings[:algorithm], settings)
    end
  end

  # method for processing the settings and inputs
  def self.process(settings)
    # default to openssl algorithm and `pwd` output directory
    settings[:algorithm] ||= :openssl
    settings[:outdir] ||= Dir.pwd

    # check for problems with arguments and inputs
    public_send("process_#{settings[:algorithm]}".to_sym, settings)
  end

  # processing openssl
  def self.process_openssl(settings)
    # check arguments
    case settings[:action]
    when :generate then return
    when :encrypt
      raise 'File, key, and nonce arguments are required for encryption.' unless settings.key?(:file) && settings.key?(:key) && settings.key?(:nonce)
    when :decrypt
      raise 'File, key, nonce, and tag arguments are required for decryption.' unless settings.key?(:file) && settings.key?(:key) && settings.key?(:nonce) && settings.key?(:tag)
    else raise 'Action must be one of generate, encrypt, or decrypt.'
    end

    # lambda for input processing
    process_input = ->(input) { File.file?(settings[input]) ? settings[input] = File.read(settings[input]) : (raise "Input #{input} is not an existing file.") }

    # check inputs and read in files
    raise 'Password must be a string.' if settings.key?(:pw) && !settings[:pw].is_a?(String)
    %i[file key nonce].each(&process_input)
    # only decrypt needs a tag input
    process_input.call(:tag) if settings[:action] == :decrypt
  end

  # processing gpgme
  def self.process_gpgme(settings)
    # check arguments
    case settings[:action]
    when :generate
      raise 'GPG params file argument required for generation.' unless settings.key?(:gpgparams)
      return
    when :decrypt, :encrypt
      raise 'File and password arguments required for encryption or decryption.' unless settings.key?(:file) && settings.key?(:pw)
    else raise 'Action must be one of generate, encrypt, or decrypt.'
    end

    # check inputs and read in files
    raise 'Password must be a string.' unless settings[:pw].is_a?(String)
    File.file?(settings[:file]) ? settings[:file] = File.read(settings[:file]) : (raise 'Input file is not an existing file.')
  end
end
