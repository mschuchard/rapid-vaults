require_relative '../spec_helper'
require_relative '../lib/rapid-vaults/cli'

describe RapidVaults::CLI do
  context '.parse' do
    it 'correctly parses the user arguments for encrypt' do
      RapidVaults::CLI.parse(%w[-e -f file.txt -k key.txt -n nonce.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt')
    end
    it 'correctly parses the arguments for decrypt' do
      RapidVaults::CLI.parse(%w[-d -f file.txt -k key.txt -n nonce.txt -t tag.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
    end
  end
end
