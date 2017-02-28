require 'openssl'

module Ppninja
  class Signature
    attr_reader :appsecret
    def initialize(appsecret)
      @appsecret = appsecret
    end

    def sign(queries, http_method, path, timestamp)
      # 1. filter parameters
      queries = {} unless queries.is_a?(Hash)
      parameters = ppj_normalization_parameters(queries)
      # 2. get string_to_sign
      string_to_sign = http_method + "\n" + path + "\n" + parameters

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
      queries = hash.keys.sort.map do |k|
        next if /^x-ppj-*/.match(k.downcase) # do not encode parameters used by encrption
        URI.encode(k.to_s) + '=' + URI.encode(hash[k].to_s)
      end
      (queries - [nil, '']).join('&')
    end
  end
end
