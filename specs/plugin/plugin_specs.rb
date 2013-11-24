$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Plugin do
    before do
      class PluginSpecTest
        include Plugin
      end
      @plugin = PluginSpecTest.new    
    end
    
    after do
      AresMUSH.send(:remove_const, :PluginSpecTest)
    end

    describe :want_command? do
      it "should return false by default" do
        @plugin.want_command?(nil).should be_false
      end
    end
    
    describe :on_command do
      it "should log a warning if someone fails to provide a command handler" do
        Log4r::Logger.root.should_receive(:warn)
        @plugin.on_command(nil, nil)
      end
    end    
  end
end