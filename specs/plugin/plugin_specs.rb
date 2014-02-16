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
    
    describe :log_command do
      it "should log the client and command by default" do
        cmd = double
        client = double
        cmd.should_receive(:to_s) { "Cmd" }
        @plugin.cmd = cmd
        Global.logger.should_receive(:debug).with("AresMUSH::PluginSpecTest: Cmd")
        @plugin.log_command
      end
    end
    
    describe :handle do
      it "should log a warning if someone fails to provide a command handler" do
        Log4r::Logger.root.should_receive(:warn)
        @plugin.on_command(nil, nil)
      end
    end    
    
    describe :on_command do
      before do
        @client = double
        @cmd = double
      end
      
      it "should crack the args" do
        @plugin.should_receive(:crack!)
        @plugin.on_command(@client, @cmd)
      end
      
      it "should log the command" do
        @plugin.stub(:validate) { nil }
        @plugin.should_receive(:log_command)
        @plugin.on_command(@client, @cmd)
      end
        
      it "should emit an error and stop if the command is invalid" do
        @plugin.should_receive(:validate) { "fail" }
        @client.should_receive(:emit_failure).with("fail")
        @plugin.should_not_receive(:handle)
        @plugin.on_command(@client, @cmd)
      end
      
      it "should handle the command if it's valid" do
        @plugin.stub(:validate) { nil }
        @client.should_not_receive(:emit_failure)
        @plugin.should_receive(:handle)
        @plugin.on_command(@client, @cmd)
      end    
    end
    
    describe :args do
      it "should return the command args" do
        cmd = double
        cmd.should_receive(:args) { "arg" }
        @plugin.cmd = cmd
        @plugin.args.should eq "arg"
      end
    end
    
    describe :switch do
      it "should return the command switch" do
        cmd = double
        cmd.should_receive(:switch) { "sw" }
        @plugin.cmd = cmd
        @plugin.switch.should eq "sw"
      end
    end
    
  end
end