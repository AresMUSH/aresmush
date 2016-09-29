$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe CommandHandler do
    
    before do
      SpecHelpers.stub_translate_for_testing 
    end
    
    describe :check_1_for_login do
      before do
        @client = double
        @cmd = double
        class PluginValidateLoginTest
          include CommandHandler
          include CommandRequiresLogin
        end
        @plugin = PluginValidateLoginTest.new(@client, @cmd, double)
      end
    
      after do
        AresMUSH.send(:remove_const, :PluginValidateLoginTest)
      end
      
      it "should reject command if not logged in" do
        @client.should_receive(:logged_in?) { false }
        @plugin.check_1_for_login.should eq 'dispatcher.must_be_logged_in'
      end
      
      it "should accept command if logged in" do
        @client.should_receive(:logged_in?) { true }
        @plugin.check_1_for_login.should eq nil
      end
    end
    
    describe :check_2_no_args do
      before do
        @client = double
        @cmd = double
        class PluginValidateRootOnlyTest
          include CommandHandler
          include CommandWithoutArgs
        end
        @plugin = PluginValidateRootOnlyTest.new(@client, @cmd, double)
      end
    
      after do
        AresMUSH.send(:remove_const, :PluginValidateRootOnlyTest)
      end

      it "should reject command if there are arguments" do
        @cmd.stub(:switch) { nil }
        @cmd.stub(:args) { "foo" }
        @plugin.check_2_no_args.should eq "dispatcher.cmd_no_args"
      end
      
      it "should accept command if there are no arguments" do
        @cmd.stub(:args) { nil }
        @cmd.stub(:switch) { nil }
        @plugin.check_2_no_args.should eq nil
      end
      
      it "should accept command with a switch and no arguments" do
        @cmd.stub(:args) { nil }
        @cmd.stub(:switch) { nil }
        @plugin.check_2_no_args.should eq nil
      end
    end          
    
    describe :check_2_arguments_present do
      before do
        @client = double
        @cmd = double
        class PluginValidateArgumentPresentTest
          include CommandHandler
          include CommandRequiresArgs
          attr_accessor :foo, :bar
          def initialize(client, cmd, enactor)
            self.required_args = [ 'foo', 'bar' ]
            self.help_topic = 'test'
            super
          end
        end
        @plugin = PluginValidateArgumentPresentTest.new(@client, @cmd, double)
        AresMUSH::Locale.stub(:translate).with("dispatcher.invalid_syntax", { :command => "test" }) { "invalid syntax" }        
      end
    
      after do
        AresMUSH.send(:remove_const, :PluginValidateArgumentPresentTest)
      end
      
      it "should reject command if a required argument is nil" do
        @plugin.stub(:foo) { nil }
        @plugin.stub(:bar) { "bar" }
        @plugin.check_2_arguments_present.should eq "invalid syntax"
      end

      it "should reject command if the other required argument is nil" do
        @plugin.stub(:foo) { "foo" }
        @plugin.stub(:bar) { nil }
        @plugin.check_2_arguments_present.should eq "invalid syntax"
      end
      
      it "should reject command if the required argument is blank" do
        @plugin.stub(:foo) { "   " }
        @plugin.stub(:bar) { "bar" }
        @plugin.check_2_arguments_present.should eq "invalid syntax"
      end
      
      it "should allow command if the argument is present" do
        @plugin.stub(:foo) { "foo" }
        @plugin.stub(:bar) { "bar" }
        @plugin.check_2_arguments_present.should eq nil
      end
    end
  end
end