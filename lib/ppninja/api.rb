require 'digest/md5'
require 'fileutils'
require_relative 'signature'
require_relative 'http_client'

module PPNinja
  class Api
    attr_reader :client, :appid, :appsecret
    def initialize(appid, appsecret, host)
      @appid = appid
      @appsecret = appsecret
      @client = HttpClient.new(host)
    end

    def upload(file_path)
      # valid file and get file md5
      raise 'FilePathError' unless File.file?(file_path)
      md5 = Digest::MD5.hexdigest(File.read(file_path))
      res = post_file '/api/job/create', file_path, params: {file_md5: md5}
      puts res
    end

    def download(token, file_path=:default)
      # token get from upload
      stat = status(token)
      return puts 'convert is not finishing.' unless stat == 'completed'
      res = get '/api/job/download', params: {token: token}, content_type: 'application/zip'
      # res is a Tempfile object
      file_path = "#{token}.zip" if file_path == :default
      FileUtils.cp res.path, file_path
      puts "write file to #{file_path}"
    end

    def status(token)
      res = get '/api/job/status', params: {token: token}
      puts res
      res["data"]["state"]
    end

    protected
    def get(path, headers = {})
      with_signature(path, 'GET', headers[:params]) do |authorization_token|
        client.get path, headers.merge(:'x-ppj-authorization' => authorization_token)
      end
    end

    def post(path, payload, headers = {})
      with_signature(path, 'POST', headers[:params]) do |authorization_token|
        client.post path, payload, headers.merge(:'x-ppj-authorization' => authorization_token)
      end
    end

    def post_file(path, file, headers = {})
      with_signature(path, 'POST', headers[:params]) do |authorization_token|
        client.post_file path, file, headers.merge(:'x-ppj-authorization' => authorization_token)
      end
    end

    def with_signature(path, http_method, params)
        timestamp = Time.now.to_i
        signature = Signature.new(@appsecret).sign(params, http_method, path, timestamp)
        authorizationStr = 'Credential=' + @appid + ',Timestamp=' + timestamp.to_s + ',Signature=' + signature
        yield(authorizationStr)
    end
  end
end
