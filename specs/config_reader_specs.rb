$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader, "#read" do

    before do
      create_temp_config_file
      @reader = ConfigReader.new(@temp_config_dir)
    end

    after do
      FileUtils.rm_rf @temp_config_dir
    end

    it "reads the server config" do
      @reader.read
      @reader.config['server'].should eq @server_config['server']
    end
    
    def create_temp_config_file
      @temp_config_dir = "#{Dir.pwd}/tmp_config"
      Dir.mkdir @temp_config_dir if !Dir.exists?(@temp_config_dir)
      @server_config = { 'server' => { 'port' => 9999, 'foo' => "Test" } }
      File.open("#{@temp_config_dir}/server.yaml", "w") do |f|
        f.write(@server_config.to_yaml)
      end
    end
  end
end