require_relative 'spec_helper'
require_relative '../lib/rapid_vaults'

describe RapidVaults do
  context '.process' do
    # prepare for support file validation tests
    require 'securerandom'
    before(:all) do
      File.write('key_bad.txt', SecureRandom.random_bytes(64).strip)
      File.write('key_good.txt', SecureRandom.random_bytes(32).strip)
      File.write('nonce_bad.txt', SecureRandom.random_bytes(24).strip)
      File.write('nonce_good.txt', SecureRandom.random_bytes(12).strip)
      File.write('tag_bad.txt', SecureRandom.random_bytes(24).strip)
      File.write('tag_good.txt', SecureRandom.random_bytes(16).strip)
      File.write('encrypted_bad.txt', SecureRandom.random_bytes(16).strip)
      File.write('encrypted_good.txt', '')
    end

    after(:all) do
      %w[key nonce tag encrypted].each { |file| File.delete("#{file}_bad.txt", "#{file}_good.txt") }
    end

    it 'raises an error for a non-string password with openssl' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b', nonce: 'c', pw: 1) }.to raise_error('Password must be a string.')
    end
    it 'raises an error for a non-string password with gpgme' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b', nonce: 'c', pw: 1) }.to raise_error('Password must be a string.')
    end
    it 'raises an error for a missing argument to generate with gpgme' do
      expect { RapidVaults.process(algorithm: :gpgme, action: :generate) }.to raise_error('GPG params file argument required for generation.')
    end
    it 'raises an error for a missing argument to encrypt with openssl' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b') }.to raise_error('File, key, and nonce arguments are required for encryption.')
    end
    it 'raises an error for a missing argument to decrypt with openssl' do
      expect { RapidVaults.process(action: :decrypt, file: 'a', key: 'b', nonce: 'c') }.to raise_error('File, key, nonce, and tag arguments are required for decryption.')
    end
    it 'raises an error for a missing argument to decrypt with gpgme' do
      expect { RapidVaults.process(algorithm: :gpgme, action: :decrypt, file: 'a') }.to raise_error('File and password arguments required for encryption or decryption.')
    end
    it 'raises an error for a missing action with openssl' do
      expect { RapidVaults.process(file: 'a', key: 'b', nonce: 'c', tag: 'd') }.to raise_error('Action must be one of generate, encrypt, or decrypt.')
    end
    it 'raises an error for a missing action with gpgme' do
      expect { RapidVaults.process(algorithm: :gpgme, file: 'a', key: 'b') }.to raise_error('Action must be one of generate, encrypt, or decrypt.')
    end
    it 'raises an error for a nonexistent input file with openssl' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b', nonce: 'c', tag: 'd') }.to raise_error('Input file \'a\' for argument \'file\' is not an existing readable file.')
    end
    it 'raises an error for a nonexistent input file with gpgme' do
      expect { RapidVaults.process(algorithm: :gpgme, action: :encrypt, file: 'a', pw: 'password') }.to raise_error('Input file \'a\' for argument \'file\' is not an existing readable file.')
    end
    it 'raises an error for an invalid key size' do
      expect { RapidVaults.process(action: :encrypt, file: "#{fixtures_dir}file.yaml", key: 'key_bad.txt', nonce: 'nonce_good.txt') }.to raise_error('The key is not a valid 32 byte key.')
    end
    it 'raises an error for an invalid nonce size' do
      expect { RapidVaults.process(action: :encrypt, file: "#{fixtures_dir}file.yaml", key: 'key_good.txt', nonce: 'nonce_bad.txt') }.to raise_error('The nonce is not a valid 12 byte nonce.')
    end
    it 'raises an error for an invalid tag size' do
      expect { RapidVaults.process(action: :decrypt, file: 'encrypted_good.txt', key: 'key_good.txt', nonce: 'nonce_good.txt', tag: 'tag_bad.txt') }.to raise_error('Tag is not 16 bytes.')
    end
    it 'raises an error for corrupted encrypted file content' do
      expect { RapidVaults.process(action: :decrypt, file: 'encrypted_bad.txt', key: 'key_good.txt', nonce: 'nonce_good.txt', tag: 'tag_good.txt') }.to raise_error('The encrypted data is not a valid multiple of 9 bytes.')
    end
    it 'reads in all input files correctly for openssl encryption' do
      expect { RapidVaults.process(action: :decrypt, file: 'encrypted_good.txt', key: 'key_good.txt', nonce: 'nonce_good.txt', tag: 'tag_good.txt', pw: 'password') }.not_to raise_exception
    end
    it 'reads in all input files correctly for gpgme decryption' do
      dummy = "#{fixtures_dir}file.yaml"
      expect { RapidVaults.process(algorithm: :gpgme, action: :decrypt, file: dummy, pw: 'password') }.not_to raise_exception
    end
  end
end
