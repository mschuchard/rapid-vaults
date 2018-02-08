require_relative 'spec_helper'
require_relative '../lib/rapid-vaults'

describe RapidVaults do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end

#  let(:rapidvaults) { RapidVaults.new('fixtures/foo.yml', 'fixtures/key.txt', 'fixtures/nonce.txt', 'fixtures/tag.txt') }

  context '.process' do
    it 'raises an error for a missing argument to encrypt' do
      RapidVaults.instance_variable_set(:@settings, action: :encrypt, file: 'a', key: 'b')
      expect { RapidVaults.process }.to raise_error('File, key, and nonce arguments are required for encryption.')
    end
    it 'raises an error for a missing argument to decrypt' do
      RapidVaults.instance_variable_set(:@settings, action: :decrypt, file: 'a', key: 'b', nonce: 'c')
      expect { RapidVaults.process }.to raise_error('File, key, nonce, and tag arguments are required for decryption.')
    end
    it 'raises an error for a missing action' do
      RapidVaults.instance_variable_set(:@settings, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { RapidVaults.process }.to raise_error('Action must be one of generate, encrypt, or decrypt.')
    end
    it 'raises an error for a nonexistent input file' do
      RapidVaults.instance_variable_set(:@settings, action: :encrypt, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { RapidVaults.process }.to raise_error('Input file is not an existing file.')
    end
    it 'reads in all input files correctly for decryption' do
      #
    end
  end
end
