$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Locale do
    before do
      @game_path = Dir.pwd
      AresMUSH.stub(:game_path) { @game_path }
      @locale = Locale.new
    end
    
    describe :locale_path do
      it "should be the game dir plus the locale dir" do
        Locale.locale_path.should eq File.join(@game_path, "locales")
      end
    end

    describe :locale do
      it "should return the I18 locale" do
        I18n.stub(:locale) { 'hu' }
        @locale.locale.should eq 'hu'
      end
    end
    
    describe :default_locale do
      it "should return the I18 default locale" do
        I18n.stub(:default_locale) { 'hu' }
        @locale.default_locale.should eq 'hu'
      end
    end
    
    describe :setup do
      before do
        Global.stub(:read_config).with("locale", "locale") { "de" } 
        Global.stub(:read_config).with("locale", "default_locale") { "en" } 
        I18n.stub(:locale=)
        I18n.stub(:default_locale=)
      end

      it "should trigger a load" do
        I18n.should_receive(:reload!)
        @locale.setup
      end
      
      it "should set the locale from the config file" do
        I18n.should_receive(:locale=).with("de")
        @locale.setup
      end
      
      it "should set the fallback locale from the config file" do
        I18n.should_receive(:default_locale=).with("en")
        @locale.setup
      end   
      
      it "should extend the I18n library with the fallback code" do
        I18n::Backend::Simple.should_receive(:send).with(:include, I18n::Backend::Fallbacks)
        @locale.setup
      end
      
    end
    
    describe :t do
      it "should return the backend's translation" do
        I18n.should_receive(:t).with('hello world') { "Hello World!" }
        t('hello world').should eq "Hello World!"
      end
      
      it "should pass along variables in the string" do
        args = { :arg => "the arg" }
        I18n.should_receive(:t).with('hello arg', args) { "Hello World with the arg!" }
        t('hello arg', args )
      end      
    end
    
    describe :l do
      it "should replace . with the number format separator" do
        I18n.should_receive(:t).with('number.format.separator') { "," }
        l("100.3").should eq "100,3"  
      end
      
      it "should return the I18n localization of a date" do
        date = Date.new
        I18n.should_receive(:l).with(date, {}) { "abc" }
        l(date).should eq "abc"
      end
      
      it "should return the I18n localization of a time" do
        time = Time.new
        I18n.should_receive(:l).with(time, {}) { "abc" }
        l(time).should eq "abc"
      end
    end
    
    describe :delocalize do
     it "should delocalize a number" do
        I18n.should_receive(:t).with('number.format.separator') { "," }
        @locale.delocalize("100,23").should eq "100.23"
      end
      
      it "should delocalize a date to the same value" do
        date = Date.new
        @locale.delocalize(date).should eq date.to_s
      end

      it "should delocalize a time to the same value" do
        time = Time.new
        @locale.delocalize(time).should eq time.to_s
      end
      
    end
    
    describe :reset_load_path do
      it "should tell the backend to clear the load path" do
        I18n.should_receive(:load_path=).with([])
        @locale.reset_load_path
      end

      it "should tell the loader to load the main locale" do
        LocaleLoader.should_receive(:load_dir).with(File.join(@game_path, "locales"))
        @locale.reset_load_path
      end
      
    end
    
    describe :reload do
      it "should tell the backend to reload" do
        I18n.should_receive(:reload!)
        @locale.reload
      end
    end
  end
end

