require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/cli'

describe RapidVaults::CLI do
  context '.parse' do
    it 'correctly parses the arguments for gpg' do
      expect(RapidVaults::CLI.parse(%w[--gpg])).to eq(algorithm: :gpgme, ui: :cli)
    end
    it 'correctly parses the user arguments for encrypt' do
      expect(RapidVaults::CLI.parse(%w[-e -k key.txt -n nonce.txt -p secret file.txt])).to eq(algorithm: :openssl, ui: :cli, action: :encrypt, key: 'key.txt', nonce: 'nonce.txt', pw: 'secret')
    end
    it 'correctly parses the arguments for decrypt' do
      expect(RapidVaults::CLI.parse(%w[-d -k key.txt -n nonce.txt -t tag.txt -p secret file.txt])).to eq(algorithm: :openssl, ui: :cli, action: :decrypt, key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt', pw: 'secret')
    end
    it 'correctly parses the arguments for generate' do
      expect(RapidVaults::CLI.parse(%w[-g])).to eq(algorithm: :openssl, ui: :cli, action: :generate)
    end
  end
end
