$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader do

    describe :read do 

      before do
        @temp_config_dir = "foo"
        @reader = ConfigReader.new(@temp_config_dir)
        Dir.stub(:foreach).with(File.join(@temp_config_dir, "config")).and_yield("a").and_yield("b")        
      end

      it "clears any previous config" do
        @reader.config['x'] = 'y'
        YamlExtensions.stub(:yaml_hash) { {} }
        @reader.read
        @reader.config.has_key?('x').should be_false
      end

      it "builds the one true yaml for the config options" do
        YamlExtensions.should_receive(:yaml_hash).with("a") { { 'server' => { 'foo' => "Test" } } }
        YamlExtensions.should_receive(:yaml_hash).with("b") { { 'server' => { 'port' => 9999 } } }
        
        @reader.read  
        @reader.config['server']['port'].should eq 9999
        @reader.config['server']['foo'].should eq "Test"
      end
    end
  end
end