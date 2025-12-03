# encrypts strings using supplied encryption settings
class Encrypt
  # encrypts a string with openssl
  def self.openssl(settings)
    require 'openssl'

    # setup the encryption parameters
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    cipher.key = settings[:key]
    cipher.iv = settings[:nonce]
    cipher.auth_data = settings.key?(:pw) ? settings[:pw] : ''

    # output the encryption and associated tag
    case settings[:ui]
    when :cli
      # efficiency assignment
      outdir = settings[:outdir]

      # check if already exists and no force flag
      if File.exist?("#{outdir}encrypted.txt") || File.exist?("#{outdir}tag.txt")
        raise "encrypted.txt or tag.txt already exists in #{outdir}. Use the --force flag to overwrite existing files." unless settings[:force]
      end

      # output to file
      File.write("#{outdir}encrypted.txt", cipher.update(settings[:file]) + cipher.final)
      File.write("#{outdir}tag.txt", cipher.auth_tag)
      puts "Your encrypted.txt and associated tag.txt for this encryption have been generated in #{outdir}."
    when :api
      # return as array
      [cipher.update(settings[:file]) + cipher.final, cipher.auth_tag]
    end
  end

  # encrypts a string with gpgme
  def self.gpgme(settings)
    require 'gpgme'

    # check if GPGHOME env was set
    puts "Environment variable 'GNUPGHOME' was not set. Files in #{Dir.home}/.gnupg will be used for authentication." unless ENV.fetch('GNUPGHOME', false)

    # setup the encryption parameters
    crypto = GPGME::Crypto.new(armor: true, pinentry_mode: GPGME::PINENTRY_MODE_LOOPBACK)

    # output the encryption and associated tag
    case settings[:ui]
    when :cli
      # efficiency assignment
      outdir = settings[:outdir]

      # check if already exists and no force flag
      if File.exist?("#{outdir}encrypted.txt")
        raise "encrypted.txt already exists in #{outdir}. Use the --force flag to overwrite existing files." unless settings[:force]
      end

      # output to file
      File.write("#{outdir}encrypted.txt", crypto.encrypt(settings[:file], symmetric: true, password: settings[:pw]).read)
      puts "Your encrypted.txt for this encryption has been generated in #{outdir}."
    when :api
      # return as string
      crypto.encrypt(settings[:file], symmetric: true, password: settings[:pw]).read
    end
  end
end
