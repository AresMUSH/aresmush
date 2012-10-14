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
    
    describe :setup do
      it "should set the locale from the config file" do
        I18n.should_receive(:locale=).with("de")
        @locale.setup
      end
    
      it "should load the locale files" do
        I18n.load_path.should_receive(:<<).with("#{Dir.pwd}/tmp_locale/de.yaml")
        I18n.load_path.should_receive(:<<).with("#{Dir.pwd}/tmp_locale/en.yaml")
        @locale.setup
      end
    end
    
    describe :t do
      it "should call the i18n translate with no args" do
        I18n.should_receive(:t).with('hello world')
        @locale.setup
        _t('hello world')
      end

      it "should call the i18n translate with args" do
        I18n.should_receive(:t).with('hello world', :a => "a", :b => "b")
        @locale.setup
        _t('hello world', :a => "a", :b => "b")
      end

    end
    
    def create_temp_locale_files
      @temp_locale_dir = "#{Dir.pwd}/tmp_locale"
      FileUtils.rm_rf @temp_locale_dir
      Dir.mkdir @temp_locale_dir
      
      @en = { 'a' => 'English' }
      write_yaml_file("en.yaml", @en)

      @de = { 'a' => 'Deutsch' }
      write_yaml_file("de.yaml", @de)      
    end
    
    def write_yaml_file(filename, contents)
      File.open("#{@temp_locale_dir}/#{filename}", "w") do |f|
        f.write(contents.to_yaml)
      end
    end
  end
end

