require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/api'

describe RapidVaults::API do
  context '.parse' do
    it 'correctly parses the settings for encrypt' do
      expect(RapidVaults::API.parse(action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', pw: 'secret')).to eq(ui: :api, action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', pw: 'secret')
    end
    it 'correctly parses the settings for decrypt' do
      expect(RapidVaults::API.parse(action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt', pw: 'secret')).to eq(ui: :api, action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt', pw: 'secret')
    end
    it 'correctly parses the settings for generate' do
      expect(RapidVaults::API.parse(action: :generate)).to eq(ui: :api, action: :generate)
    end
    it 'correctly overrides the algorithm setting' do
      expect(RapidVaults::API.parse(algorithm: :gpgme)).to eq(algorithm: :gpgme, ui: :api)
    end
  end
end
