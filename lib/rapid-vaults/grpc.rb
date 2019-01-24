require_relative '../rapid-vaults'

# provides a grpc server
class RapidVaults::GRPC < Rapidvaults::RapidVaults::Service
  # start the server
  def server
    addr = '0.0.0.0:8080'
    server = GRPC::RpcServer.new
    server.add_http2_port(addr, :this_port_is_insecure)
    server.handle(RapidVaults.new)
    server.run_till_terminated
  end

  # grpc api for generate openssl
  def ssl_generate(geninputs, _call)
    settings = geninputs.to_hash
    settings_process(settings)
    Generate.openssl(settings)
  end

  # grpc api for generate gpg
  def gpg_generate(geninputs, _call)
    settings = geninputs.to_hash
    settings_process(settings)
    Generate.gpgme(settings)
  end

  # grpc api for encrypt ssl
  def ssl_encrypt(unencrypted, _call)
    settings = {}
    settings[:file] = unencrypted.text
    settings[:key] = unencrypted.key
    settings[:nonce] = unencrypted.nonce
    settings[:pw] = unencrypted.password
    settings_process(settings)
    Encrypt.openssl(settings)
  end

  # grpc api for encrypt gpg
  def gpg_encrypt(unencrypted, _call)
    settings = {}
    settings[:file] = unencrypted.text
    settings[:pw] = unencrypted.password
    settings_process(settings)
    Encrypt.gpgme(settings)
  end

  # grpc api for ssl decrypt
  def ssl_decrypt(undecrypted, _call)
    settings = {}
    settings[:file] = undecrypted.text
    settings[:key] = undecrypted.key
    settings[:nonce] = undecrypted.nonce
    settings[:tag] = undecrypted.tag
    settings[:pw] = undecrypted.password
    settings_process(settings)
    Decrypt.openssl(settings)
  end

  # grpc api for gpg decrypt
  def gpg_decrypt(undecrypted, _call)
    settings = {}
    settings[:file] = undecrypted.text
    settings[:pw] = undecrypted.password
    settings_process(settings)
    Decrypt.gpgme(settings)
  end

  private

  # helper method
  def settings_process(settings)
    settings[:ui] = :api
    RapidVaults.process(settings)
    settings
  end
end
