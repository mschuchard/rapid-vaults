require_relative '../spec_helper'
require_relative '../lib/rapid-vaults/generate'

describe RapidVaults do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

  context '.generate' do
    it 'generates the key and nonce files from the cli' do
      RapidVaults.generate
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true
    end
  end
end
