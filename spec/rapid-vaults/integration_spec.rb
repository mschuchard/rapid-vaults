require_relative '../spec_helper'
require_relative '../../lib/rapid-vaults/integration'

describe Integration do
  context '.puppet' do
    after(:all) do
      %w[puppet_gpg_decrypt.rb puppet_gpg_encrypt.rb puppet_ssl_decrypt.rb puppet_ssl_encrypt.rb].each { |file| File.delete(file) }
    end

    it 'outputs the puppet integrations to the specified directory' do
      Integration.puppet({})
      %w[puppet_gpg_decrypt.rb puppet_gpg_encrypt.rb puppet_ssl_decrypt.rb puppet_ssl_encrypt.rb].each do |file|
        expect(File.file?(file)).to be true
      end
    end
  end

  context '.chef' do
    after(:all) do
      File.delete('chef.rb')
    end

    it 'outputs the chef integrations to the specified directory' do
      Integration.chef({})
      expect(File.file?('chef.rb')).to be true
    end
  end
end
