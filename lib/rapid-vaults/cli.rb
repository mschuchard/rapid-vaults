require_relative '../rapid-vaults'

# provides a command line interface to interact with rapid vaults
class RapidVaults::CLI
  # point of entry from executable
  def self.main(args)
    # parse args in cli and denote using cli
    parse(args)
    unless RapidVaults.settings[:action] == :generate
      args.empty? ? (raise 'rapid-vaults: no file specified; try using --help') : RapidVaults.settings[:file] = args.first
    end

    # run RapidVaults with specified file
    RapidVaults.new.main
    0
  end

  # parse cli options
  def self.parse(args)
    require 'optparse'

    # show help message if no args specified
    args = %w[-h] if args.empty?

    # specify cli being used
    RapidVaults.settings[:ui] = :cli

    opt_parser = OptionParser.new do |opts|
      # usage
      opts.banner = 'usage: rapid-vaults [options] file'

      # generate, encrypt, or decrypt
      opts.on('-g', '--generate', 'Generate a key and nonce for encryption and decryption.') { RapidVaults.settings[:action] = :generate }
      opts.on('-e', '--encrypt', 'Encrypt a file using a key and nonce and generate a tag.') { RapidVaults.settings[:action] = :encrypt }
      opts.on('-d', '--decrypt', 'Decrypt a file using a key, nonce, and tag.') { RapidVaults.settings[:action] = :decrypt }

      # key, nonce, and tag
      opts.on('-k', '--key key', String, 'Key file to be used for encryption or decryption.') { |arg| RapidVaults.settings[:key] = arg }
      opts.on('-n', '--nonce nonce', String, 'Nonce file to be used for encryption or decryption.') { |arg| RapidVaults.settings[:nonce] = arg }
      opts.on('-t', '--tag tag', String, 'Tag file to be used for decryption.') { |arg| RapidVaults.settings[:tag] = arg }
    end

    opt_parser.parse!(args)
  end
end
