if RUBY_VERSION.to_f >= 2.3
  require_relative '../../lib/rapid-vaults/grpc'

  # TODO: use RapidVaults::GRPC.server instead?
  stub = Rapidvaults::RapidVaults::Stub.new('localhost:0.0.0.0:8080', :this_channel_is_insecure)
end

# need to create class with encode member method to pass in as dummy
# ssl generate
# outputs = stub.ssl_generate('string')
=begin
puts outputs.key
puts outputs.nonce

# gpg generate
stub.gpg_generate

# ssl encrypt
# TODO: unencrypted should be an object
unencrypted.text = ''
unencrypted.key = ''
unencrypted.nonce = ''
outputs = stub.ssl_encrypt(unencrypted)
puts outputs.text
puts outputs.tag

# gpg encrypt
unencrypted.text = ''
unencrypted.password = ''
puts stub.gpg_encrypt(unencrypted).text

# ssl decrypt
# TODO: undecrypted should be an object
undecrypted.text = ''
undecrypted.key = ''
undecrypted.nonce = ''
undecrypted.tag = ''
puts stub.ssl_decrypt(undecrypted).text

# gpg decrypt
undecrypted.text = ''
undecrypted.password = ''
puts stub.gpg_decrypt(undecrypted).text
=end
