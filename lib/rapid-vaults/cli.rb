require_relative '../rapid-vaults'

# provides a command line interface to interact with rapid vaults
class RapidVaults::CLI
  # point of entry from executable
  def self.main(args)
    # parse args in cli and denote using cli
    settings = parse(args)
    unless settings[:action] == :generate
      args.empty? ? (raise 'rapid-vaults: no file specified; try using --help') : settings[:file] = args.first
    end

    # run RapidVaults with specified file
    RapidVaults.new.main(settings)
    0
  end

  # parse cli options
  def self.parse(args)
    require 'optparse'

    # show help message if no args specified
    args = %w[-h] if args.empty?

    # init settings
    settings = {}
    # specify cli being used
    settings[:ui] = :cli
    # default to openssl algorithm
    settings[:algorithm] = :openssl

    opt_parser = OptionParser.new do |opts|
      # usage
      opts.banner = 'usage: rapid-vaults [options] file'

      # use gpg instead
      opts.on('--gpg', 'Use GNUPG/GPG instead of GNUTLS/OpenSSL for encryption/decryption.') { settings[:algorithm] = :gpgme }

      # generate, encrypt, or decrypt
      opts.on('-g', '--generate', 'Generate a key and nonce for encryption and decryption (GPG: n/a).') { settings[:action] = :generate }
      opts.on('-e', '--encrypt', 'Encrypt a file using a key and nonce and generate a tag (GPG: key only).') { settings[:action] = :encrypt }
      opts.on('-d', '--decrypt', 'Decrypt a file using a key, nonce, and tag (GPG: key only).') { settings[:action] = :decrypt }

      # key, nonce, password, and tag
      opts.on('-k', '--key key', String, 'Key file to be used for encryption or decryption.') { |arg| settings[:key] = arg }
      opts.on('-n', '--nonce nonce', String, 'Nonce file to be used for encryption or decryption (GPG: n/a).') { |arg| settings[:nonce] = arg }
      opts.on('-t', '--tag tag', String, 'Tag file to be used for decryption (GPG: n/a).') { |arg| settings[:tag] = arg }
      opts.on('-p', '--password password', String, '(optional) Password to be used for encryption or decryption (GPG: required).') { |arg| settings[:pw] = arg }
      opts.on('-f', '--file-password password.txt', String, '(optional) Text file containing a password to be used for encryption or decryption (GPG: required).') { |arg| settings[:pw] = File.read(arg) }

      # gpg params file
      opts.on('--gpgparams params.txt', String, 'GPG Key params input file used during generation of keys.') { |arg| settings[:gpgparams] = File.read(arg) }
    end

    # parse args and return settings
    opt_parser.parse!(args)
    settings
  end
end
