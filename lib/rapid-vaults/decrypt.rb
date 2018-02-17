require 'openssl'
require_relative '../rapid-vaults'

class Decrypt
  # decrypts a string
  def self.main
    # check tag size
    raise 'Tag is not 16 bytes.' unless RapidVaults.settings[:tag].bytesize == 16

    # setup the decryption parameters
    decipher = OpenSSL::Cipher.new('aes-256-gcm').decrypt
    decipher.key = RapidVaults.settings[:key]
    decipher.iv = RapidVaults.settings[:nonce]
    decipher.auth_tag = RapidVaults.settings[:tag]
    decipher.auth_data = ''

    # output the decrypted file
    if RapidVaults.settings[:ui] == :cli
      # output to file
      File.write('decrypted.txt', decipher.update(RapidVaults.settings[:file]) + decipher.final)
      puts 'Your decrypted.txt has been written out to the current directory.'
    elsif RapidVaults.settings[:ui] == :api
      # output to string
      decipher.update(RapidVaults.settings[:file]) + decipher.final
    end
  end
end
