require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/api'

describe RapidVaults::API do
  context '.main' do
    it 'correctly parses the settings for encrypt' do
      RapidVaults::API.main(action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt')
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :api, action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt')
    end
    it 'correctly parses the settings for decrypt' do
      RapidVaults::API.main(action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :api, action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
    end
    it 'correctly parses the settings for decrypt' do
      RapidVaults::API.main(action: :generate)
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(ui: :api, action: :generate)
    end
  end
end
