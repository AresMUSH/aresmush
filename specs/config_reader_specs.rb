$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader do

    describe :read do 
      before do
        create_temp_config_files
        @reader = ConfigReader.new(@temp_config_dir)
      end

      after do
        FileUtils.rm_rf @temp_config_dir
      end

      it "clears any previous config" do
        @reader.config['x'] = 'y'
        @reader.read
        @reader.config.has_key?('x').should be_false
      end

      it "clears any previous txt" do
        @reader.txt['x'] = 'y'
        @reader.read
        @reader.txt.has_key?('x').should be_false
      end

      it "builds the one true yaml for the config options" do
        YamlExtensions.should_receive(:one_yaml_to_rule_them_all).with(@temp_config_dir + "/config") { { 'server' => { 'port' => 9999, 'foo' => "Test" } } }
        @reader.read  
        @reader.config['server']['port'].should eq 9999
        @reader.config['server']['foo'].should eq "Test"
      end

      it "reads the first txt file" do
        @reader.read
        @reader.txt['test1'].should eq @txt1
      end

      it "reads the second txt file" do
        @reader.read
        @reader.txt['test2'].should eq @txt2
      end

      def create_temp_config_files
        @temp_config_dir = "#{Dir.pwd}/tmp_config"
        FileUtils.rm_rf @temp_config_dir
        Dir.mkdir @temp_config_dir
        Dir.mkdir "#{@temp_config_dir}/config"
        Dir.mkdir "#{@temp_config_dir}/txt"

        @txt1 = "A\nB"
        @txt2 = "C\nD"
        File.open("#{@temp_config_dir}/txt/test1.txt", "w") { |f| f.write(@txt1)}
        File.open("#{@temp_config_dir}/txt/test2.txt", "w") { |f| f.write(@txt2)}
      end
    end
  end
end