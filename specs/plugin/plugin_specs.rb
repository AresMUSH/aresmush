$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Plugin do
    before do
      class PluginSpecTest
        include Plugin
        
        def check_x
          return "error_x" if cmd.raw == "x marks the spot"
          return nil
        end
        
        def check_y
          return "error_y" if cmd.raw == "y marks the spot"
          return nil
        end
      end
      @plugin = PluginSpecTest.new   
      SpecHelpers.stub_translate_for_testing 
    end
    
    after do
      AresMUSH.send(:remove_const, :PluginSpecTest)
    end

    describe :want_command? do
      it "should return false by default" do
        @plugin.want_command?(nil, nil).should be_false
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
        @plugin.on_command(nil, Command.new("test"))
      end
    end    
    
    describe :on_command do
      before do
        @client = double
        @cmd = double
        @cmd.stub(:raw) { "raw" }
        @cmd.stub(:switch) { nil }
      end
      
      it "should crack the args" do
        @plugin.should_receive(:crack!)
        @plugin.on_command(@client, @cmd)
      end
      
      it "should log the command" do
        @plugin.stub(:check) { nil }
        @plugin.should_receive(:log_command)
        @plugin.on_command(@client, @cmd)
      end
        
      it "should call all check methods" do
        @plugin.should_receive(:check_x) { nil }
        @plugin.should_receive(:check_y) { nil }
        @plugin.on_command(@client, @cmd)
      end
      
      it "should emit an error and stop if any validator fails" do
        @cmd.stub(:raw) { "x marks the spot" }
        @client.should_receive(:emit_failure).with("error_x")
        @plugin.should_not_receive(:handle)
        @plugin.on_command(@client, @cmd)
      end
      
      it "should emit an error and stop if any validator fails" do
        @cmd.stub(:raw) { "y marks the spot" }
        @client.should_receive(:emit_failure).with("error_y")
        @plugin.should_not_receive(:handle)
        @plugin.on_command(@client, @cmd)
      end
      
      it "should handle the command if it's valid" do
        @plugin.stub(:check) { nil }
        @client.should_not_receive(:emit_failure)
        @plugin.should_receive(:handle)
        @plugin.on_command(@client, @cmd)
      end    
    end  
    
    describe :trim_input do
      it "should return nil for nil" do
        @plugin.trim_input(nil).should eq nil
      end
      
      it "should return a titleized string" do
        @plugin.trim_input("   someTHING   ").should eq "someTHING"
      end
    end
    
    describe :titleize_input do
      it "should return nil for nil" do
        @plugin.titleize_input(nil).should eq nil
      end
      
      it "should return a titleized string" do
        @plugin.titleize_input("   someTHING   ").should eq "Something"
      end
    end
  end
end