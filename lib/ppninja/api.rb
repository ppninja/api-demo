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

    def list(conditions = nil)
      res = get '/api/job/list', params: conditions
      puts res
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
      with_signature(path, 'GET', headers[:params]) do |sub_headers|
        client.get path, headers.merge(sub_headers)
      end
    end

    def post(path, payload, headers = {})
      with_signature(path, 'POST', headers[:params]) do |sub_headers|
        client.post path, payload, headers.merge(sub_headers)
      end
    end

    def post_file(path, file, headers = {})
      with_signature(path, 'POST', headers[:params]) do |sub_headers|
        client.post_file path, file, headers.merge(sub_headers)
      end
    end

    def with_signature(path, http_method, params)
        timestamp = Time.now.to_i
        signature = Signature.new(@appsecret).sign(params, http_method, path, timestamp)
        # authorizationStr = 'Credential=' + @appid + ',Timestamp=' + timestamp.to_s + ',Signature=' + signature
        # yield(:'x-ppj-authorization' => authorizationStr)
        authorization_params = {
            :"X-Ppj-Credential" => @appid,
            # :"X-Ppj-Mode" => 'test'            # 设置queries里面X-Ppj-Mode = ‘test’ 可以不通过签名算法，进行后续api操作
            :"X-Ppj-Timestamp" => timestamp,
            :"X-Ppj-Signature" => signature
        }
        yield(params: params.merge(authorization_params))
    end
  end
end
