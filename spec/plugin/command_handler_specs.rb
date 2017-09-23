$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandHandler do
    before do
      class PluginSpecTest
        include CommandHandler
        
        attr_accessor :x, :y
        
        def check_x
          return "error_x" if self.x == "x marks the spot"
          return nil
        end
        
        def check_y
          return "error_y" if self.y == "y marks the spot"
          return nil
        end
        
        def handle
        end
      end
      
      class PluginSpecTestAllowWithoutLogin
        include CommandHandler
        
        def allow_without_login
          true
        end
        
        def handle
        end
      end
      
      class PluginSpecTestRequiredArgs
        include CommandHandler
        
        attr_accessor :foo, :bar
        def required_args
          [ self.foo, self.bar ]
        end
        
        def handle
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
        @cmd.stub(:root) { "root" }
        @char.stub(:name) { "Bob" }
        @cmd.stub(:root_plus_switch) { "root/switch" }
        @client.stub(:logged_in?) { true }
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should parse the args" do
        @handler.should_receive(:parse_args)
        @handler.on_command
      end
      
      it "should log the command" do
        @handler.stub(:check) { nil }
        @handler.should_receive(:log_command)
        @handler.on_command
      end
        
      it "should fail if not logged in" do
        @client.stub(:logged_in?) { false }
        @client.should_receive(:emit_failure).with("dispatcher.must_be_logged_in")
        @handler.on_command
      end
        
      it "should not fail if not logged in when the command allows it" do
        @handler = PluginSpecTestAllowWithoutLogin.new(@client, @cmd, @char)
        @client.stub(:logged_in?) { false }
        @client.should_not_receive(:emit_failure)
        @handler.on_command
      end
      
      it "should fail if a required arg is missing" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = nil
        @handler.bar = "here"
        @client.should_receive(:emit_failure).with("dispatcher.invalid_syntax")
        @handler.on_command
      end
      
      it "should fail if a required arg is blank" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = "here"
        @handler.bar = "    "
        @client.should_receive(:emit_failure).with("dispatcher.invalid_syntax")
        @handler.on_command
      end
      
      it "should pass if all required args are present" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = "here"
        @handler.bar = "there"
        @client.should_not_receive(:emit_failure)
        @handler.on_command
      end
      
      it "should not care about required args if none are specified" do
        @handler.x = nil
        @handler.y = "     "
        @client.should_not_receive(:emit_failure)
        @handler.on_command
      end
      
      
      it "should call all check methods but do nothing if they return nil" do
        @handler.should_receive(:check_x) { nil }
        @handler.should_receive(:check_y) { nil }
        @client.should_not_receive(:emit_failure)
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @handler.x = "x marks the spot"
        @client.should_receive(:emit_failure).with("error_x")
        @handler.should_not_receive(:handle)
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @handler.y = "y marks the spot"
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
    
    describe :trim_arg do
      before do
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        @handler.trim_arg(nil).should eq nil
      end
      
      it "should return a /help/d string" do
        @handler.trim_arg("   someTHING   ").should eq "someTHING"
      end
    end
    
    describe :titlecase_arg do
      before do 
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        @handler.titlecase_arg(nil).should eq nil
      end
      
      it "should return a /help/d string" do
        @handler.titlecase_arg("   someTHING   ").should eq "Something"
      end
    end
  end
end