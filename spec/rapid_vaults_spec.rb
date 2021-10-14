require_relative 'spec_helper'
require_relative '../lib/rapid_vaults'

describe RapidVaults do
  context '.process' do
    it 'raises an error for a non-string password with openssl' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b', nonce: 'c', pw: 1) }.to raise_error('Password must be a string.')
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
    it 'raises an error for a missing argument to generate with gpgme' do
      expect { RapidVaults.process(algorithm: :gpgme, action: :generate) }.to raise_error('GPG params file argument required for generation.')
    end
    it 'raises an error for a nonexistent input file' do
      expect { RapidVaults.process(action: :encrypt, file: 'a', key: 'b', nonce: 'c', tag: 'd') }.to raise_error('Input file is not an existing file.')
    end
    it 'reads in all input files correctly for openssl encryption' do
      dummy = "#{fixtures_dir}file.yaml"
      expect { RapidVaults.process(action: :encrypt, file: dummy, key: dummy, nonce: dummy, pw: 'password') }.not_to raise_exception
    end
    it 'reads in all input files correctly for gpgme decryption' do
      dummy = "#{fixtures_dir}file.yaml"
      expect { RapidVaults.process(algorithm: :gpgme, action: :decrypt, file: dummy, pw: 'password') }.not_to raise_exception
    end
  end
end
