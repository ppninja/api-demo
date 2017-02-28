require 'ppninja/version'
require 'ppninja/api'
require 'ppninja/api_loader'

module Ppninja
  # Your code goes here...

  def self.config(account = :default)
    ApiLoader.config(account)
  end

  def self.api(account = :default)
    @ppninja_apis ||= {}
    @ppninja_apis[account.to_sym] ||= ApiLoader.with(account: account)
  end
end
