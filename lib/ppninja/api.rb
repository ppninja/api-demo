require 'json'
require 'digest/md5'
require 'rest-client'
require_relative 'signature'

module PPNinja
  class Api
    attr_reader :appid, :appsecret, :host
    def initialize(appid, appsecret, host)
      @appid = appid
      @appsecret = appsecret
      @host = host
    end

    def upload(file_path)
      # valid file and get file md5
      raise 'FilePathError' unless File.file?(file_path)
      md5 = Digest::MD5.hexdigest(File.read(file_path))
      payload = {
        file_source: File.new(file_path, 'rb'),
        file_md5: md5
      }

      response = send_request(nil, payload, 'POST', '/api/job/create')
      puts 'response: ', JSON.parse(response.body)
      JSON.parse(response.body)["data"]["token"]
    end

    def status(token)
      # token get from upload
      response = send_request({token: token}, nil, 'GET', '/api/job/status')
      puts 'response: ', JSON.parse(response.body)
      JSON.parse(response.body)["data"]["state"]
    end

    def download(token, file_path=:default)
      # token get from upload
      stat = status(token)
      return puts 'convert is not finishing.' unless stat == 'completed'

      response = send_request({token: token}, nil, 'GET', '/api/job/download')
      file_path = "#{token}.zip" if file_path == :default
      File.write(file_path, response.to_s)
    end

    protected

    def send_request(queries, payload, http_method, path)
      timestamp = Time.now.to_i
      signature = Signature.new(@appsecret).sign(queries, payload, http_method, path, timestamp)
      authorizationStr = 'Credential=' + @appid + ',Timestamp=' + timestamp.to_s + ',Signature=' + signature

      RestClient::Request.execute(method: (http_method == 'POST' ? :post : :get), url: (@host + path).to_s,
                                  timeout: 10, payload: payload, headers: {
                                    params: queries,
                                    'x-ppj-authorization' => authorizationStr
                                  })
    end
  end
end
