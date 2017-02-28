require 'active_support/hash_with_indifferent_access'
require 'yaml'

module Ppninja
  module ApiLoader
    def self.with(options)
      account = options[:account] || :default
      c = ApiLoader.config(account)

      if c.appid && c.appsecret
        Ppninja::Api.new(c['appid'], c['appsecret'], c['host'])
      else
        puts <<-HELP
          Need create ~/.ppninja_credentials with ppninja appid & appsecret
          HELP
        exit 1
      end
    end

    @configs = nil

    def self.config(account = :default)
      account = :default if account.nil?
      @configs ||= loading_config!
      @configs[account.to_sym] || raise("Ppninja configuration for #{account} is missing.")
    end

    private_class_method def self.loading_config!
      configs = config_from_file || config_from_environment
      configs.symbolize_keys!
      configs.each do |key, cfg|
        if cfg.is_a?(Hash)
          cfg.symbolize_keys!
        else
          raise "wrong ppninja configuration format for #{key}"
        end
      end

      # create config object using raw config data
      cfg_objs = {}
      configs.each do |account, cfg|
        cfg_objs[account] = OpenStruct.new(cfg)
      end
      cfg_objs
    end

    private_class_method def self.config_from_file
      if defined?(::Rails)
        config_file = ENV['PPNINJA_CONF_FILE'] || Rails.root.join('config/ppninja.yml')
        resovle_config_file(config_file, Rails.env.to_s)
      else
        rails_config_file = ENV['PPNINJA_CONF_FILE'] || File.join(Dir.getwd, 'config/ppninja.yml')
        application_config_file = File.join(Dir.getwd, 'config/application.yml')
        home_config_file = File.join(Dir.home, '.ppninja.yml')

        if File.exist?(rails_config_file)
          if File.exist?(application_config_file) && !defined?(::Figaro)
            require 'figaro'
            Figaro::Application.new(path: application_config_file).load
          end
          rails_env = ENV['RAILS_ENV'] || 'development'
          config = resovle_config_file(rails_config_file, rails_env)
          if config && (default = config[:default]) && (default['appid'])
            return config
          end
        end
        if File.exist?(home_config_file)
          return resovle_config_file(home_config_file, nil)
        end
      end
    end

    private_class_method def self.resovle_config_file(config_file, env)
      if File.exist?(config_file)
        raw_data = YAML.load(ERB.new(File.read(config_file)).result)
        configs = {}
        if env
          # Process multiple accounts when env is given
          raw_data.each do |key, value|
            if key == env
              configs[:default] = value
            elsif m = /(.*?)_#{env}$/.match(key)
              configs[m[1].to_sym] = value
            end
          end
        else
          # Treat is as one account when env is omitted
          configs[:default] = raw_data
        end
        configs
      end
    end

    private_class_method def self.config_from_environment
      value = { appid: ENV['PPNINJA_APPID'],
                appsecret: ENV['PPNINJA_APPSECRET'],
                host: ENV['PPNINJA_HOST'] }
      { default: value }
    end

    private_class_method def self.class_exists?(class_name)
      return Module.const_get(class_name).present?
    rescue NameError
      return false
    end
  end
end
