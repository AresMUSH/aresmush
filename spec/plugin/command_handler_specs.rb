

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
      
      stub_translate_for_testing 
    end
    
    after do
      AresMUSH.send(:remove_const, :PluginSpecTest)
    end
    
    describe :log_command do
      it "should log the client and command by default" do
        cmd = double
        char = double
        client = double
        expect(client).to receive(:to_s) { "client" }
        expect(cmd).to receive(:to_s) { "Cmd" }
        allow(char).to receive(:name) { "Bob" }
        @handler = PluginSpecTest.new(client, cmd, char)
        expect(Global.logger).to receive(:debug).with("AresMUSH::PluginSpecTest: client Enactor=Bob Cmd=Cmd")
        @handler.log_command
      end
    end
    
    describe :on_command do
      before do
        @client = double
        @cmd = double
        @char = double
        @room = double
        allow(@client).to receive(:char_id) { 22 }
        allow(Character).to receive(:find) { @char }
        allow(@char).to receive(:room) { @room }
        allow(@cmd).to receive(:raw) { "raw" }
        allow(@cmd).to receive(:switch) { nil }
        allow(@cmd).to receive(:root) { "root" }
        allow(@char).to receive(:name) { "Bob" }
        allow(@cmd).to receive(:root_plus_switch) { "root/switch" }
        allow(@client).to receive(:logged_in?) { true }
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should parse the args" do
        expect(@handler).to receive(:parse_args)
        @handler.on_command
      end
      
      it "should log the command" do
        allow(@handler).to receive(:check) { nil }
        expect(@handler).to receive(:log_command)
        @handler.on_command
      end
        
      it "should fail if not logged in" do
        allow(@client).to receive(:logged_in?) { false }
        expect(@client).to receive(:emit_failure).with("dispatcher.must_be_logged_in")
        @handler.on_command
      end
        
      it "should not fail if not logged in when the command allows it" do
        @handler = PluginSpecTestAllowWithoutLogin.new(@client, @cmd, @char)
        allow(@client).to receive(:logged_in?) { false }
        expect(@client).to_not receive(:emit_failure)
        @handler.on_command
      end
      
      it "should fail if a required arg is missing" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = nil
        @handler.bar = "here"
        expect(@client).to receive(:emit_failure).with("dispatcher.invalid_syntax")
        @handler.on_command
      end
      
      it "should fail if a required arg is blank" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = "here"
        @handler.bar = "    "
        expect(@client).to receive(:emit_failure).with("dispatcher.invalid_syntax")
        @handler.on_command
      end
      
      it "should pass if all required args are present" do
        @handler = PluginSpecTestRequiredArgs.new(@client, @cmd, @char)
        @handler.foo = "here"
        @handler.bar = "there"
        expect(@client).to_not receive(:emit_failure)
        @handler.on_command
      end
      
      it "should not care about required args if none are specified" do
        @handler.x = nil
        @handler.y = "     "
        expect(@client).to_not receive(:emit_failure)
        @handler.on_command
      end
      
      
      it "should call all check methods but do nothing if they return nil" do
        expect(@handler).to receive(:check_x) { nil }
        expect(@handler).to receive(:check_y) { nil }
        expect(@client).to_not receive(:emit_failure)
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @handler.x = "x marks the spot"
        expect(@client).to receive(:emit_failure).with("error_x")
        expect(@handler).to_not receive(:handle)
        @handler.on_command
      end
      
      it "should emit an error and stop if any validator fails" do
        @handler.y = "y marks the spot"
        expect(@client).to receive(:emit_failure).with("error_y")
        expect(@handler).to_not receive(:handle)
        @handler.on_command
      end
      
      it "should handle the command if it's valid" do
        allow(@handler).to receive(:check) { nil }
        expect(@client).to_not receive(:emit_failure)
        expect(@handler).to receive(:handle)
        @handler.on_command
      end    
    end  
    
    describe :trim_arg do
      before do
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        expect(@handler.trim_arg(nil)).to eq nil
      end
      
      it "should return a /help/d string" do
        expect(@handler.trim_arg("   someTHING   ")).to eq "someTHING"
      end
    end
    
    describe :titlecase_arg do
      before do 
        @handler = PluginSpecTest.new(@client, @cmd, @char)
      end
      
      it "should return nil for nil" do
        expect(@handler.titlecase_arg(nil)).to eq nil
      end
      
      it "should return a /help/d string" do
        expect(@handler.titlecase_arg("   someTHING   ")).to eq "Something"
      end
    end
  end
end
