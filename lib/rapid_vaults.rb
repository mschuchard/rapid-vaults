require_relative 'rapid-vaults/decrypt'
require_relative 'rapid-vaults/encrypt'
require_relative 'rapid-vaults/generate'
require_relative 'rapid-vaults/binding'

# interfaces from cli/api, validates settings, and then distributes actions to appropriate classes
class RapidVaults
  # main runner for software
  def main(settings)
    # process settings via pass-by-reference
    self.class.process(settings)

    # execute desired action and algorithm via dynamic call
    case settings[:action]
    when :generate then Generate.public_send(settings[:algorithm], settings)
    when :encrypt then Encrypt.public_send(settings[:algorithm], settings)
    when :decrypt then Decrypt.public_send(settings[:algorithm], settings)
    when :binding then Binding.public_send(settings[:binding], settings)
    end
  end

  # method for processing the settings and inputs
  def self.process(settings)
    # default to openssl algorithm and `pwd` output directory
    if settings[:ui] == :cli
      # :outdir only relevant for :cli
      settings[:outdir] ||= Dir.pwd
      settings[:outdir] += '/' unless settings[:outdir][-1] == '/'
    end

    return if settings[:action] == :binding
    settings[:algorithm] ||= :openssl

    # check for problems with arguments and inputs
    public_send(:"process_#{settings[:algorithm]}", settings)
  end

  # processing openssl
  def self.process_openssl(settings)
    private_class_method :method
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
    process_input = ->(input) { File.readable?(settings[input]) ? settings[input] = File.read(settings[input]) : (raise "Input file '#{settings[input]}' for argument '#{input}' is not an existing readable file.") }

    # check inputs and read in files
    raise 'Password must be a string.' if settings.key?(:pw) && !settings[:pw].is_a?(String)
    %i[file key nonce].each(&process_input)

    # validate key and nonce
    raise 'The key is not a valid 32 byte key.' unless settings[:key].bytesize == 32
    raise 'The nonce is not a valid 12 byte nonce.' unless settings[:nonce].bytesize == 12

    # decrypt: check inputs and read in files, and validate encrypted and tag
    return unless settings[:action] == :decrypt
    process_input.call(:tag) if settings[:action] == :decrypt

    raise 'The encrypted data is not a valid multiple of 9 bytes.' unless (settings[:file].bytesize % 9).zero?
    raise 'Tag is not 16 bytes.' unless settings[:tag].bytesize == 16
  end

  # processing gpgme
  def self.process_gpgme(settings)
    private_class_method :method
    # check arguments
    case settings[:action]
    when :generate
      raise 'GPG params file argument required for generation.' unless settings.key?(:gpgparams)
    when :decrypt, :encrypt
      # check inputs and read in files
      raise 'File and password arguments required for encryption or decryption.' unless settings.key?(:file) && settings.key?(:pw)
      raise 'Password must be a string.' unless settings[:pw].is_a?(String)
      settings[:file] = File.readable?(settings[:file]) ? File.read(settings[:file]) : (raise "Input file '#{settings[:file]}' for argument 'file' is not an existing readable file.")
    else raise 'Action must be one of generate, encrypt, or decrypt.'
    end
  end
end
