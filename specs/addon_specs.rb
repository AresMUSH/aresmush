$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  
  
  describe Addon do
    before do
      class AddonSpecTest
        include Addon
      end
      @addon = AddonSpecTest.new(nil)      
    end
    
    after do
      AresMUSH.send(:remove_const, :AddonSpecTest)
    end

    describe :want_command? do
      it "should return false by default" do
        @addon.want_command?(nil).should be_false
      end
    end
    
    describe :on_command do
      it "should log a warning if someone fails to provide a command handler" do
        Log4r::Logger.root.should_receive(:warn)
        @addon.on_command(nil, nil)
      end
    end    
  end
end