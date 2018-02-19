require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/cli'

describe RapidVaults::CLI do
  context '.parse' do
    it 'correctly parses the user arguments for encrypt' do
      RapidVaults::CLI.parse(%w[-e -k key.txt -n nonce.txt file.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :cli, action: :encrypt, key: 'key.txt', nonce: 'nonce.txt')
    end
    it 'correctly parses the arguments for decrypt' do
      RapidVaults::CLI.parse(%w[-d -k key.txt -n nonce.txt -t tag.txt file.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :cli, action: :decrypt, key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
    end
    it 'correctly parses the arguments for generate' do
      RapidVaults.instance_variable_set(:@settings, {})
      RapidVaults::CLI.parse(%w[-g])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :cli, action: :generate)
    end
  end
end
