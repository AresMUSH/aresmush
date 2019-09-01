module AresMUSH

  name = ENV['ares_rake_param']
  if (!name)
    puts "You must specify a plugin name."
    exit
  end  
  
  path = File.join(AresMUSH.plugin_path, name)
  if (Dir.exist?(path))
    puts "That plugin already exists."
    exit
  end
  
  config_file_path = File.join(AresMUSH.game_path, "config", "#{name}.yml")
  if (File.exist?(config_file_path))
    puts "Creating that plugin would overwrite an existing config file.  Choose a different name."
    exit
  end
  
  if (name !~ /^[a-z0-9]+$/)
    puts "Plugin names may only contain lowercase letters and numbers."
    exit
  end
  
  Dir.mkdir(path)
  Dir.mkdir File.join(path, 'help')
  Dir.mkdir File.join(path, 'help', 'en')
  Dir.mkdir File.join(path, 'commands')
  locale_dir = File.join(path, 'locales')  
  Dir.mkdir locale_dir
  
  File.open(File.join(locale_dir, 'locale_en.yml'), 'w') do |file|
    yaml = { 'en' => { name => { }}}
    file.puts yaml.to_yaml
  end
  
  File.open(File.join(AresMUSH.game_path, 'config', "#{name}.yml"), 'w') do |file|
    yaml = { name => { } }
    file.puts yaml.to_yaml
  end
  
  File.open(File.join(path, "#{name}.rb"), 'w') do |file|
    file.puts "$:.unshift File.dirname(__FILE__)"
    file.puts ""
    file.puts "module AresMUSH"
    file.puts "     module #{name.camelize}"
    file.puts ""
    file.puts "    def self.plugin_dir"
    file.puts "      File.dirname(__FILE__)"
    file.puts "    end"
    file.puts ""
    file.puts "    def self.shortcuts"
    file.puts "      Global.read_config(\"#{name}\", \"shortcuts\")"
    file.puts "    end"
    file.puts ""
    file.puts "    def self.get_cmd_handler(client, cmd, enactor)"     
    file.puts "      nil"
    file.puts "    end"
    file.puts ""
    file.puts "    def self.get_event_handler(event_name)"     
    file.puts "      nil"
    file.puts "    end"
    file.puts ""
    file.puts "    def self.get_web_request_handler(request)"
    file.puts "      nil"
    file.puts "    end"
    file.puts ""
    file.puts "  end"
    file.puts "end"
  end
  
  puts "Script complete!"
end