

require "aresmush"

module AresMUSH

  describe Locale do
    before do
      @root_path = Dir.pwd
      allow(AresMUSH).to receive(:root_path) { @root_path }
      @locale = Locale.new
    end
    
    describe :locale_path do
      it "should be the game dir plus the locale dir" do
        expect(Locale.locale_path).to eq File.join(@root_path, "engine", "locales")
      end
    end

    describe :locale do
      it "should return the I18 locale" do
        allow(I18n).to receive(:locale) { 'hu' }
        expect(@locale.locale).to eq 'hu'
      end
    end
    
    describe :default_locale do
      it "should return the I18 default locale" do
        allow(I18n).to receive(:default_locale) { 'hu' }
        expect(@locale.default_locale).to eq 'hu'
      end
    end
    
    describe :setup do
      before do
        allow(Global).to receive(:read_config).with("locale", "locale") { "de" } 
        allow(Global).to receive(:read_config).with("locale", "default_locale") { "en" } 
        allow(I18n).to receive(:locale=)
        allow(I18n).to receive(:default_locale=)
      end

      it "should trigger a load" do
        expect(I18n).to receive(:reload!)
        @locale.setup
      end
      
      it "should set the locale from the config file" do
        expect(I18n).to receive(:locale=).with("de")
        @locale.setup
      end
      
      it "should set the fallback locale from the config file" do
        expect(I18n).to receive(:default_locale=).with("en")
        @locale.setup
      end   
      
      it "should extend the I18n library with the fallback code" do
        expect(I18n::Backend::Simple).to receive(:send).with(:include, I18n::Backend::Fallbacks)
        @locale.setup
      end
      
    end
    
    describe :t do
      it "should return the backend's translation" do
        expect(I18n).to receive(:t).with('hello world') { "Hello World!" }
        expect(t('hello world')).to eq "Hello World!"
      end
      
      it "should pass along variables in the string" do
        args = { :arg => "the arg" }
        expect(I18n).to receive(:t).with('hello arg', args) { "Hello World with the arg!" }
        t('hello arg', :arg => "the arg" )
      end      
    end
    
    describe :l do
      it "should replace . with the number format separator" do
        expect(I18n).to receive(:t).with('number.format.separator') { "," }
        expect(l("100.3")).to eq "100,3"  
      end
      
      it "should return the I18n localization of a date" do
        date = Date.new
        expect(I18n).to receive(:l).with(date) { "abc" }
        expect(l(date)).to eq "abc"
      end
      
      it "should return the I18n localization of a time" do
        time = Time.new
        expect(I18n).to receive(:l).with(time) { "abc" }
        expect(l(time)).to eq "abc"
      end
    end
    
    describe :delocalize do
     it "should delocalize a number" do
        expect(I18n).to receive(:t).with('number.format.separator') { "," }
        expect(@locale.delocalize("100,23")).to eq "100.23"
      end
      
      it "should delocalize a date to the same value" do
        date = Date.new
        expect(@locale.delocalize(date)).to eq date.to_s
      end

      it "should delocalize a time to the same value" do
        time = Time.new
        expect(@locale.delocalize(time)).to eq time.to_s
      end
      
    end
    
    describe :reset_load_path do
      it "should tell the backend to clear the load path" do
        expect(I18n).to receive(:load_path=).with([])
        @locale.reset_load_path
      end

      it "should tell the loader to load the main locale" do
        allow(@locale).to receive(:locale_order) { [ "en" ]}
        expect(LocaleLoader).to receive(:load_file).with(File.join(@root_path, "engine", "locales", "locale_en.yml"))
        @locale.reset_load_path
      end
      
    end
    
    describe :reload do
      it "should tell the backend to reload" do
        expect(I18n).to receive(:reload!)
        @locale.reload
      end
    end
  end
end

