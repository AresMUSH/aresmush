$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Locale do
    before do
      @temp_dir = Dir.pwd + "/tmp_locale"
      create_temp_locale_files
      @config_reader = double(ConfigReader)
      @config_reader.stub(:config) { { 'server' => { 'locale' => "de", "fallback_locale" => "en" } } }
      @locale = Locale.new(@config_reader, @temp_dir)
      @locale.setup
    end

    after do
      FileUtils.rm_rf @temp_dir
    end
    
    describe :setup do
      it "should set the locale from the config file" do
        @locale.locale.should eq :de
      end
      
      it "should set the fallback locale from the config file" do
        @locale.default_locale.should eq :en
      end
      
      it "should load the locale files" do
        I18n.available_locales.should include :en
        I18n.available_locales.should include :de
      end
    end
    
    describe :t do
      it "should translate a string to the current locale" do
        t('hello world').should eq "Hallo Erde!"
      end

      it "should fall back to the default locale if the string isn't found" do
        t('goodbye').should eq "Goodbye world!"
      end
      
      it "should give an error string if not found in the default locale" do
        t('foo').should eq "translation missing: de.foo"
      end
      
      it "should expand variables into the string" do
        t('hello arg', :arg => "my" ).should eq "Hallo my Erde!"
      end
      
    end
    
    describe :l do
      it "should localize a number" do
        l("100.3").should eq "100,3"  
      end
    end
    
    describe :delocalize do
     it "should delocalize a number" do
        @locale.delocalize("100,23").should eq "100.23"
      end
    end

    def create_temp_locale_files
           Dir.mkdir @temp_dir
           y = 
           { "en" => 
              { 
               "hello world" => "Hello world!", 
               "goodbye" => "Goodbye world!" 
               } 
           }
           File.open(@temp_dir + "/en.yml", 'w') {|f| f.write(y.to_yaml) }

           y = 
           { 
             "de" =>
              { 
                "hello world" => "Hallo Erde!", 
                "hello arg" => "Hallo %{arg} Erde!",
                "number" =>
                    {
                     "format" =>
                       {
                         "separator" => ","
                       }
                    } 
              } 
           }
           File.open(@temp_dir + "/de.yml", 'w') {|f| f.write(y.to_yaml) }
      
        
    end
    
  end
end

