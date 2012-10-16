$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Locale do
    before do
      @temp_dir = Dir.pwd + "/tmp_locale"
      Dir.mkdir @temp_dir
      @config_reader = double(ConfigReader)
      @config_reader.stub(:config) { { 'server' => { 'locale' => "de", "fallback_locale" => "en" } } }
      @locale = Locale.new(@config_reader, @temp_dir)
    end

    after do
      FileUtils.rm_rf @temp_dir
    end
    
    describe :setup do
      it "should set the locale from the config file" do
        @locale.setup
        @locale.locale.should eq "de"
      end
      
      it "should set the fallback locale from the config file" do
        @locale.setup
        @locale.fallback_locale.should eq "en"
      end
      
      it "should load the locale files" do
        YamlExtensions.should_receive(:one_yaml_to_rule_them_all).with(@temp_dir)
        @locale.setup
      end
    end
    
    describe :t do
      it "should translate a string to the current locale" do
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { {"de" => { "hello world" => "Hello World!" }} }
        @locale.setup
        t('hello world').should eq "Hello World!"
      end

      it "should fall back to the default locale if the string isn't found" do
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { {"en" => { "hello world" => "Hello World!" }} }
        @locale.setup
        t('hello world').should eq "Hello World!"
      end
      
      it "should give the original string if not found in the default locale" do
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { {"en" => { "hello world" => "Hello World!" }} }
        @locale.setup
        t('goodbye world').should eq "goodbye world"
      end
      
      it "should expand variables into the string" do
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { {"de" => { "hello world" => "Hello %{arg} World!" }} }
        @locale.setup
        t('hello world', :arg => "my" ).should eq "Hello my World!"
      end
      
    end
    
    describe :l do
      it "should localize a number" do
        config = { 'de' => { 'number' => { 'separator' => ',' } } }
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { config }
        @locale.setup
        l("100.3").should eq "100,3"  
      end
    end
    
    describe :delocalize do
      it "should delocalize a number" do
        config = { 'de' => { 'number' => { 'separator' => ',' } } }
        YamlExtensions.stub(:one_yaml_to_rule_them_all) { config }
        @locale.setup
        @locale.delocalize("100,23").should eq "100.23"
      end
    end
        
  end
end

