$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader do

    describe :read do 

      before do
        @temp_config_dir = "foo"
        @reader = ConfigReader.new(@temp_config_dir)
        YamlExtensions.should_receive(:one_yaml_to_rule_them_all).with(@temp_config_dir + "/config") { { 'server' => { 'port' => 9999, 'foo' => "Test" } } }
      end

      it "clears any previous config" do
        @reader.config['x'] = 'y'
        @reader.read
        @reader.config.has_key?('x').should be_false
      end

      it "builds the one true yaml for the config options" do
        @reader.read  
        @reader.config['server']['port'].should eq 9999
        @reader.config['server']['foo'].should eq "Test"
      end
    end
  end
end