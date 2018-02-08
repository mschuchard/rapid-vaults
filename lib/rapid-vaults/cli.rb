class RapidVaults::CLI
  # point of entry from executable
  def self.cli(args)
    # parse args in cli and denote using cli
    parse(args)
    args.empty? ? (raise 'rapid-vaults: no file specified; try using --help') : @settings[:file] = args.first
    @settings[:ui] = :cli

    # process settings
    process

    # execute desired action
    public_send(@settings[:action])
    0
  end

  # parse cli options
  def self.parse(args)
    require 'optparse'

    # show help message if no args specified
    args = %w[-h] if args.empty?

    opt_parser = OptionParser.new do |opts|
      # usage
      opts.banner = 'usage: rapid-vaults [options] file'

      # generate, encrypt, or decrypt
      opts.on('-g', '--generate', 'Generate a key and nonce for encryption and decryption.') { @settings[:action] = :generate }
      opts.on('-e', '--encrypt', 'Encrypt a file using a key and nonce and generate a tag.') { @settings[:action] = :encrypt }
      opts.on('-d', '--decrypt', 'Decrypt a file using a key, nonce, and tag.') { @settings[:action] = :decrypt }

      # key, nonce, and tag
      opts.on('-k', '--key key', String, 'Key file to be used for encryption or decryption.') { |arg| @settings[:key] = arg }
      opts.on('-n', '--nonce nonce', String, 'Nonce file to be used for encryption or decryption.') { |arg| @settings[:nonce] = arg }
      opts.on('-t', '--tag tag', String, 'Tag file to be used for decryption.') { |arg| @settings[:tag] = arg }
    end

    opt_parser.parse!(args)
  end
end
