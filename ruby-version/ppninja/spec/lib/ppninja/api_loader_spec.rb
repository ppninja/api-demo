require 'spec_helper'

RSpec.describe Ppninja::ApiLoader do

  it 'should config' do
    expect(Ppninja.config.appid).to eq 'appid'
    expect(Ppninja.config(:default).appid).to eq 'appid'
  end

  it 'should load config file' do
    clear_wechat_configs
    ENV['PPNINJA_CONF_FILE'] = File.join(Dir.getwd, 'spec/dummy/config/dummy_ppninja.yml')

    expect(Ppninja.config.appid).to eq 'my_appid'
    expect(Ppninja.config.appsecret).to eq 'my_secret'
    expect(Ppninja.config.host).to eq 'my_host'
    expect(Ppninja.config(:default).appid).to eq 'my_appid'
    expect(Ppninja.config(:default).appsecret).to eq 'my_secret'
    expect(Ppninja.config(:default).host).to eq 'my_host'

    clear_wechat_configs
    # alter environment
    current_env = ENV['RAILS_ENV'] || 'test'
    ENV['RAILS_ENV'] = 'development'
    expect(Ppninja.config.appid).to eq 'my_appid'
    expect(Ppninja.config.appsecret).to eq 'my_development_secret'
    expect(Ppninja.config.host).to eq 'my_development_host'
    expect(Ppninja.config(:default).appid).to eq 'my_appid'
    expect(Ppninja.config(:default).appsecret).to eq 'my_development_secret'
    expect(Ppninja.config(:default).host).to eq 'my_development_host'

    ENV['RAILS_ENV'] = current_env

    clear_wechat_configs
    ENV['PPNINJA_CONF_FILE'] = nil
  end

  it 'should create api for account' do
    clear_wechat_configs
    ENV['PPNINJA_CONF_FILE'] = File.join(Dir.getwd, 'spec/dummy/config/dummy_ppninja.yml')
    default_api = Ppninja::ApiLoader.with({})
    expect(default_api.appid).to eq 'my_appid'

    clear_wechat_configs
    ENV['WECHAT_CONF_FILE'] = nil
  end

  def clear_wechat_configs
    Ppninja::ApiLoader.class_eval do
      @configs = nil
    end
  end
end
