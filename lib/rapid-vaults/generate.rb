# generates files necessary for encryption and decryption
class Generate
  # generates a key and nonce
  def self.openssl(settings)
    require 'openssl'

    # setup parameters
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt

    case settings[:ui]
    when :cli
      # efficiency assignment
      outdir = settings[:outdir]

      # check if already exists and no force flag
      if File.exist?("#{outdir}key.txt") || File.exist?("#{outdir}nonce.txt")
        raise "key.txt or nonce.txt already exists in #{outdir}. Use the --force flag to overwrite existing files." unless settings[:force]
      end

      # output to file
      File.write("#{outdir}key.txt", cipher.random_key)
      File.write("#{outdir}nonce.txt", cipher.random_iv)
      puts "Your key.txt and nonce.txt have been generated in #{outdir}."
    when :api
      # return as array
      [cipher.random_key, cipher.random_iv]
    end
  end

  # generates a private and public key
  def self.gpgme(settings)
    require 'gpgme'

    # ensure we have a place to store these output files
    raise 'Environment variable "GNUPGHOME" was not set.' unless ENV.fetch('GNUPGHOME', false)

    # check if already exists and no force flag
    if Dir.exist?(ENV['GNUPGHOME']) && !Dir.empty?(ENV['GNUPGHOME'])
      raise "GPG keyring in #{ENV['GNUPGHOME']} already exists and is not empty. Use the --force flag to overwrite existing files." unless settings[:force]
    end

    # create gpg keys
    GPGME::Ctx.new.generate_key(settings[:gpgparams], nil, nil)
    puts "Your GPG keys have been generated in #{ENV.fetch('GNUPGHOME')}." if settings[:ui] == :cli
  end
end
