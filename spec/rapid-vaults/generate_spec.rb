require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/generate'

describe Generate do
  after(:all) do
    %w[key.txt nonce.txt].each { |file| File.delete(file) }
  end

  context '.openssl' do
    it 'generates the key and nonce files from the cli' do
      Generate.openssl(ui: :cli)
      expect(File.file?('key.txt')).to be true
      expect(File.file?('nonce.txt')).to be true
      expect(File.read('key.txt')).to be_a(String)
      expect(File.read('nonce.txt')).to be_a(String)
    end
    it 'outputs an array with the key and nonce from the api' do
      generate = Generate.openssl(ui: :api)
      expect(generate).to be_a(Array)
      expect(generate[0]).to be_a(String)
      expect(generate[1]).to be_a(String)
      expect(generate.length).to eq(2)
    end
  end

  context '.gpgme' do
    it 'generates the key files from the cli' do
      Generate.gpgme(ui: :cli)
      expect(File.directory?("#{Dir.home}/.gnupg")).to be true
    end
    it 'outputs an array with the keys from the api' do
      generate = Generate.gpgme(ui: :api)
      expect(File.directory?("#{Dir.home}/.gnupg")).to be true
    end
  end
end
