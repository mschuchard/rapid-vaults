require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/generate'

describe Generate do
  context '.openssl' do
    after(:all) do
      %w[key.txt nonce.txt].each { |file| File.delete(file) }
    end

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
    it 'raises an error for a missing GNUPGHOME variable' do
      expect { Generate.gpgme(gpgparams: File.read("#{fixtures_dir}/gpgparams.txt")) }.to raise_error('Environment variable GNUPGHOME was not set.')
    end
    # travis ci cannot support non-interactive gpg
    unless File.directory?('/home/travis')
      it 'generates the key files' do
        require 'fileutils'

        ENV['GNUPGHOME'] = fixtures_dir

        Generate.gpgme(gpgparams: File.read("#{fixtures_dir}/gpgparams.txt"))
        %w[trustdb.gpg pubring.kbx pubring.kbx~].each do |file|
          expect(File.file?("#{fixtures_dir}/#{file}")).to be true
          File.delete("#{fixtures_dir}/#{file}")
        end
        %w[openpgp-revocs.d private-keys-v1.d].each do |dir|
          expect(File.directory?("#{fixtures_dir}/#{dir}")).to be true
          FileUtils.rm_r("#{fixtures_dir}/#{dir}")
        end
        %w[S.gpg-agent random_seed].each { |file| File.delete("#{fixtures_dir}/#{file}") if File.exist?(file) }
      end
    end
  end
end
