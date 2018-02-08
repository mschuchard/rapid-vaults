require_relative '../spec_helper'
require_relative '../lib/rapid-vaults/cli'

describe RapidVaults::CLI do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context '.parse' do
    it 'correctly parses the user arguments for encrypt' do
      RapidVaults.parse(%w[-e -f file.txt -k key.txt -n nonce.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(action: :encrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt')
    end
    it 'correctly parses the arguments for decrypt' do
      RapidVaults.parse(%w[-d -f file.txt -k key.txt -n nonce.txt -t tag.txt])
      expect(RapidVaults.instance_variable_get(:@settings)).to eq(action: :decrypt, file: 'file.txt', key: 'key.txt', nonce: 'nonce.txt', tag: 'tag.txt')
    end
  end
end
