require 'openssl'

module PPNinja
  class Signature
    attr_reader :appsecret
    def initialize(appsecret)
      @appsecret = appsecret
    end

    def sign(queries, payload, http_method, path, timestamp)
      # 1. filter parameters
      queries = {} unless queries.is_a?(Hash)
      payload = {} unless payload.is_a?(Hash)

      parameters = ppj_normalization_parameters(payload.merge(queries))
      # 2. get string_to_sign
      string_to_sign = http_method + "\n" + path + "\n" + (parameters.empty? ? '' : parameters.to_json)

      encrypt(string_to_sign, timestamp)
    end

    def encrypt(string_to_sign, timestamp)
      # 1. get derived_key
      digest = OpenSSL::Digest.new('sha256')
      derived_key = OpenSSL::HMAC.hexdigest(digest, timestamp.to_s, @appsecret)

      # 2. using derived_key to sign the string_to_sign
      signature = OpenSSL::HMAC.hexdigest(digest, derived_key, string_to_sign)

      # return
      signature
    end

    private

    def ppj_normalization_parameters(hash)
      return hash unless hash.is_a?(Hash)

      return_hash = {}
      hash.keys.sort.each do |k|
        next if hash[k].respond_to?('path') && File.exist?(hash[k].path)
        next if %w(x-ppj-credential x-ppj-timestamp x-ppj-signature).include?(k.downcase) # do not encode parameters used by encrption
        return_hash[k] = ppj_normalization_parameters(hash[k])
      end
      return_hash
    end
  end
end
