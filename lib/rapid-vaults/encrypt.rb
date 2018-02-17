require 'openssl'
require_relative '../rapid-vaults'

class Encrypt
  # encrypts a string
  def self.main
    # setup the encryption parameters
    cipher = OpenSSL::Cipher.new('aes-256-gcm').encrypt
    cipher.key = RapidVaults.settings[:key]
    cipher.iv = RapidVaults.settings[:nonce]
    cipher.auth_data = ''

    # output the encrypted file and associated tag
    if RapidVaults.settings[:ui] == :cli
      # output to file
      File.write('encrypted.txt', cipher.update(RapidVaults.settings[:file]) + cipher.final)
      File.write('tag.txt', cipher.auth_tag)
      puts 'Your encrypted.txt and associated tag.txt for this encryption have been generated in your current directory.'
    elsif RapidVaults.settings[:ui] == :api
      # output to array
      [cipher.update(RapidVaults.settings[:file]) + cipher.final, cipher.auth_tag]
    end
  end
end
