$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandHandler do
    before do
      class PluginSpecTest
        include CommandHandler
        
        def check_x
          return "error_x" if cmd.raw == "x marks the spot"
          return nil
        end
        
        def check_y
          return "error_y" if cmd.raw == "y marks the spot"
          return nil
        end
      end
      SpecHelpers.stub_translate_for_testing 
    end
    
    after do
      AresMUSH.send(:remove_const, :PluginSpecTest)
    end
    
    describe :log_command do
      it "should log the client and command by default" do
        cmd = double
        char = double
        client = double
        client.should_receive(:to_s) { "client" }
        cmd.should_receive(:to_s) { "Cmd" }
        char.stub(:name) { "Bob" }
        @handler = PluginSpecTest.new(client, cmd, char)
        Global.logger.should_receive(:debug).with("AresMUSH::PluginSpecTest: client Enactor=Bob Cmd=Cmd")
        @handler.log_command
      end
    end
    
    describe :on_command do
      before do
        @client = double
        @cmd = double
        @char = double
        @room = double
        @client.stub(:char_id) { 22 }
        Character.stub(:find) { @char }
        @char.stub(:room) { @room }
        @cmd.stub(:raw) { "raw" }
        @cmd.stub(:switch) { nil }
        @char.stub(:name) { "Bob" }
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should crack the args" do
        @handler.should_receive(:crack!)
        @handler.on_command
      end
      
      it "should log the command" do
        @handler.stub(:check) { nil }
        @handler.should_receive(:log_command)
        @handler.on_command
      end
        
      it "should call all check methods" do
        @handler.should_receive(:check_x) { nil }
        @handler.should_receive(:check_y) { nil }
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @cmd.stub(:raw) { "x marks the spot" }
        @client.should_receive(:emit_failure).with("error_x")
        @handler.should_not_receive(:handle)
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @cmd.stub(:raw) { "y marks the spot" }
        @client.should_receive(:emit_failure).with("error_y")
        @handler.should_not_receive(:handle)
        @handler.on_command
      end
      
      it "should handle the command if it's valid" do
        @handler.stub(:check) { nil }
        @client.should_not_receive(:emit_failure)
        @handler.should_receive(:handle)
        @handler.on_command
      end    
    end  
    
    describe :trim_input do
      before do
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        @handler.trim_input(nil).should eq nil
      end
      
      it "should return a titleized string" do
        @handler.trim_input("   someTHING   ").should eq "someTHING"
      end
    end
    
    describe :titleize_input do
      before do 
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        @handler.titleize_input(nil).should eq nil
      end
      
      it "should return a titleized string" do
        @handler.titleize_input("   someTHING   ").should eq "Something"
      end
    end
  end
end