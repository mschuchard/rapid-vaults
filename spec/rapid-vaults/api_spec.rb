require_relative '../spec_helper'
require_relative '../lib/rapid-vaults/api'

describe RapidVaults::API do
  after(:all) do
    %w[key.txt nonce.txt tag.txt encrypted.txt decrypted.txt].each { |file| File.delete(file) }
  end
end
