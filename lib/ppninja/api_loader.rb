module PPNinja
  module ApiLoader
    def self.with(options)
      config_path = options[:config] || '~/.ppninja_credentials'
      unless File.file?(config_path)
        puts <<-HELP
        Need create ~/.ppninja_credentials with ppninja appid & appsecret
        HELP
        exit 1
      end

      configs = YAML.load(File.read(config_path))
      PPNinja::Api.new(configs['appid'], configs['appsecret'], configs['host'])
    end
  end
end
