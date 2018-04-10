require_relative 'spec_helper'
require_relative '../lib/rapid-vaults'

describe RapidVaults do
  #  let(:rapidvaults) { RapidVaults.new('fixtures/foo.yml', 'fixtures/key.txt', 'fixtures/nonce.txt', 'fixtures/tag.txt') }

  context '.process' do
    it 'raises an error for a non-string password with openssl' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, action: :encrypt, file: 'a', key: 'b', nonce: 'c', pw: 1)
      expect { RapidVaults.process }.to raise_error('Password must be a string.')
    end
    it 'raises an error for a missing argument to encrypt with openssl' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, action: :encrypt, file: 'a', key: 'b')
      expect { RapidVaults.process }.to raise_error('File, key, and nonce arguments are required for encryption.')
    end
    it 'raises an error for a missing argument to decrypt with openssl' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, action: :decrypt, file: 'a', key: 'b', nonce: 'c')
      expect { RapidVaults.process }.to raise_error('File, key, nonce, and tag arguments are required for decryption.')
    end
    it 'raises an error for a missing argument to with gpgme' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :gpgme, action: :decrypt, file: 'a')
      expect { RapidVaults.process }.to raise_error('File and GPG key argument required for encryption or decryption.')
    end
    it 'raises an error for a missing action with openssl' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { RapidVaults.process }.to raise_error('Action must be one of generate, encrypt, or decrypt.')
    end
    it 'raises an error for a missing action with gpgme' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :gpgme, file: 'a', key: 'b')
      expect { RapidVaults.process }.to raise_error('Action must be encrypt or decrypt.')
    end
    it 'raises an error for attempting to generate with gpgme' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :gpgme, action: :generate)
      expect { RapidVaults.process }.to raise_error('GPG key generation is currently not supported.')
    end
    it 'raises an error for a nonexistent input file' do
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, action: :encrypt, file: 'a', key: 'b', nonce: 'c', tag: 'd')
      expect { RapidVaults.process }.to raise_error('Input file is not an existing file.')
    end
    it 'reads in all input files correctly for decryption' do
      dummy = fixtures_dir + 'file.yaml'
      RapidVaults.instance_variable_set(:@settings, algorithm: :openssl, action: :encrypt, file: dummy, key: dummy, nonce: dummy, pw: 'password')
      expect { RapidVaults.process }.not_to raise_exception
    end
  end
end
