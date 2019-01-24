require_relative '../../lib/grpc'

stub = Rapidvaults::RapidVaults::Stub.new('localhost:0.0.0.0:8080')

# ssl generate
outputs = stub.ssl_generate
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
