$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"
require 'yaml'

module AresMUSH

  describe ConfigReader, "#read" do

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
    
    it "reads the server config" do
      @reader.read
      @reader.config['server'].should eq @server_config['server']
    end
    
    it "reads the connect config" do
      @reader.read
      @reader.config['connect'].should eq @connect_config['connect']
    end
    
    it "reads the first txt file" do
      @reader.read
      @reader.txt['test1'].should eq @txt1
    end

    it "reads the first txt file" do
      @reader.read
      @reader.txt['test2'].should eq @txt2
    end
    
    def create_temp_config_files
      @temp_config_dir = "#{Dir.pwd}/tmp_config"
      FileUtils.rm_rf @temp_config_dir
      Dir.mkdir @temp_config_dir
      Dir.mkdir "#{@temp_config_dir}/config"
      Dir.mkdir "#{@temp_config_dir}/txt"
      
      @server_config = { 'server' => { 'port' => 9999, 'foo' => "Test" } }
      write_yaml_file("server.yml", @server_config)
      
      @connect_config = { 'connect' => { 'welcome_text' => "Hi there!" }}
      write_yaml_file("connect.yml", @connect_config)
      
      @txt1 = "A\nB"
      @txt2 = "C\nD"
      File.open("#{@temp_config_dir}/txt/test1.txt", "w") { |f| f.write(@txt1)}
      File.open("#{@temp_config_dir}/txt/test2.txt", "w") { |f| f.write(@txt2)}
    end
    
    def write_yaml_file(filename, contents)
      File.open("#{@temp_config_dir}/config/#{filename}", "w") do |f|
        f.write(contents.to_yaml)
      end
    end
  end
end