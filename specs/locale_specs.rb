$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Locale do
    before do
      @config_reader = double(ConfigReader)
      @config_reader.stub(:config) { { 'server' => { 'locale' => "de" } } }
      create_temp_locale_files
      @locale = Locale.new(@config_reader, @temp_locale_dir)
    end

    after do
        FileUtils.rm_rf @temp_locale_dir
    end
    
    describe :setup do
      it "should set the locale from the config file" do
        I18n.should_receive(:locale=).with("de")
        @locale.setup
      end
    
      it "should load the locale files" do
        @locale.setup
        I18n.load_path.should include "#{Dir.pwd}/tmp_locale/de.yml"
        I18n.load_path.should include "#{Dir.pwd}/tmp_locale/en.yml"
      end
    end
    
    describe :t do
      it "should call i18n translate with no args" do
        I18n.should_receive(:t).with('hello world')
        @locale.setup
        t('hello world')
      end

      it "should call i18n translate with args" do
        I18n.should_receive(:t).with('hello world', :a => "a", :b => "b")
        @locale.setup
        t('hello world', :a => "a", :b => "b")
      end
    end
    
    describe :l do
      it "should call i18n localize for a date with no args " do
        test_date = Date.parse("2012-10-15")
        I18n.should_receive(:l).with(test_date, {})
        @locale.setup
        l(test_date)
      end

      it "should call i18n localize for a date with args " do
        test_date = Date.parse("2012-10-15")
        I18n.should_receive(:l).with(test_date, :format => "short")
        @locale.setup
        l(test_date, :format => "short")
      end
      
      it "should call i18n localize for a time with args" do
        test_time = Time.parse("12:23 am")
        I18n.should_receive(:l).with(test_time, :format => "short")
        @locale.setup
        l(test_time, :format => "short")
      end
      
      it "should call i18n localize for a time with no args" do
        test_time = Time.parse("12:23 am")
        I18n.should_receive(:l).with(test_time, {})
        @locale.setup
        l(test_time)
      end
      
      it "should localize a number" do
        I18n.should_receive(:t).with('number.format.separator') { "," }
        @locale.setup
        l("100.3").should eq "100,3"  
      end
    end
    
    describe :delocalize do
      it "should delocalize a number" do
        I18n.should_receive(:t).with('number.format.separator') { "," }
        @locale.setup
        Locale.delocalize("100,23").should eq "100.23"
      end
    end
        
    
    describe :enable_fallbacks do
      it "should set the default locale to english" do
        I18n.should_receive(:default_locale=).with("en")
        @locale.setup
      end
    end
    
    def create_temp_locale_files
      @temp_locale_dir = "#{Dir.pwd}/tmp_locale"
      
      FileUtils.rm_rf @temp_locale_dir
      Dir.mkdir @temp_locale_dir
      
      @en = { 'en' => { 'a' => 'English' } }
      write_yaml_file("en.yml", @en)

      @de = { 'de' => { 'a' => 'Deutsch' } }
      write_yaml_file("de.yml", @de)      
    end
    
    def write_yaml_file(filename, contents)
      File.open("#{@temp_locale_dir}/#{filename}", "w") do |f|
        f.write(contents.to_yaml)
      end
    end
  end
end

