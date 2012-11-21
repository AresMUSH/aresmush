$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader do

    describe :read do 

      before do
        @temp_config_dir = "foo"
        AresMUSH.stub(:game_dir) { @temp_config_dir }
        @reader = ConfigReader.new
        Dir.stub(:regular_files) { ["a", "b"] }
      end

      it "clears any previous config" do
        @reader.config['x'] = 'y'
        YamlExtensions.stub(:yaml_hash) { {} }
        @reader.read
        @reader.config.has_key?('x').should be_false
      end

      it "reads the individual config files" do
        YamlExtensions.should_receive(:yaml_hash).with("a") { { 'server' => { 'foo' => "Test" } } }
        YamlExtensions.should_receive(:yaml_hash).with("b") { { 'server' => { 'port' => 9999 } } }
        
        @reader.read 
        puts @reader.config 
        @reader.config['server']['port'].should eq 9999
        @reader.config['server']['foo'].should eq "Test"
      end
    end
  end
end