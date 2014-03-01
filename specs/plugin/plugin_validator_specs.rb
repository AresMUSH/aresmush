$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Plugin do
    before do
      SpecHelpers.stub_translate_for_testing 
    end
    
    describe :validate_check_for_login do
      before do
        @client = double
        @cmd = double
        class PluginValidateLoginTest
          include Plugin
          must_be_logged_in        
        end
        @plugin = PluginValidateLoginTest.new 
        @plugin.client = @client
        @plugin.cmd = @cmd
      end
    
      after do
        AresMUSH.send(:remove_const, :PluginValidateLoginTest)
      end
      
      it "should reject command if not logged in" do
        @client.should_receive(:logged_in?) { false }
        @plugin.validate_check_for_login.should eq 'dispatcher.must_be_logged_in'
      end
      
      it "should accept command if logged in" do
        @client.should_receive(:logged_in?) { true }
        @plugin.validate_check_for_login.should eq nil
      end
    end
    
    describe :validate_no_args do
      before do
        @client = double
        @cmd = double
        class PluginValidateRootOnlyTest
          include Plugin
          no_args
        end
        @plugin = PluginValidateRootOnlyTest.new 
        @plugin.client = @client
        @plugin.cmd = @cmd
      end
    
      after do
        AresMUSH.send(:remove_const, :PluginValidateRootOnlyTest)
      end

      it "should reject command if there are arguments" do
        @cmd.stub(:switch) { nil }
        @cmd.stub(:args) { "foo" }
        @plugin.validate_no_args.should eq "dispatcher.cmd_no_switches_or_args"
      end
      
      it "should accept command if there are no arguments" do
        @cmd.stub(:args) { nil }
        @cmd.stub(:switch) { nil }
        @plugin.validate_no_args.should eq nil
      end
      
      it "should accept command with a switch and no arguments" do
        @cmd.stub(:args) { nil }
        @cmd.stub(:switch) { nil }
        @plugin.validate_no_args.should eq nil
      end
    end    
      
    describe :validate_allowed_switches do
      context "with allowed switches" do
        before do
          @client = double
          @cmd = double
          class PluginValidateAllowSwitchTest
            include Plugin
            allow_switches ["test1", "test2"]
          end
          @plugin = PluginValidateAllowSwitchTest.new 
          @plugin.client = @client
          @plugin.cmd = @cmd
        end
    
        after do
          AresMUSH.send(:remove_const, :PluginValidateAllowSwitchTest)
        end
      
        it "should reject command if the switch doesn't match" do
          @cmd.stub(:switch) { "foo" }
          @plugin.validate_allowed_switches.should eq "dispatcher.cmd_invalid_switch"
        end
      
        it "should allow command if there is no switch" do
          @cmd.stub(:switch) { nil }
          @plugin.validate_allowed_switches.should eq nil
        end

        it "should allow command if it matches an allowed switch" do
          @cmd.stub(:switch) { "test1" }
          @plugin.validate_allowed_switches.should eq nil
        end

        it "should allow command if it matches another allowed switch" do
          @cmd.stub(:switch) { "test2" }
          @plugin.validate_allowed_switches.should eq nil
        end
      end
      
      context "with no switches allowed" do
        before do
          @client = double
          @cmd = double
          class PluginValidateNoSwitchTest
            include Plugin
            no_switches
          end
          @plugin = PluginValidateNoSwitchTest.new 
          @plugin.client = @client
          @plugin.cmd = @cmd
        end
    
        after do
          AresMUSH.send(:remove_const, :PluginValidateNoSwitchTest)
        end
      
        it "should reject command if there is a switch" do
          @cmd.stub(:switch) { "foo" }
          @plugin.validate_allowed_switches.should eq "dispatcher.cmd_no_switches"
        end
      
        it "should allow command if there is no switch" do
          @cmd.stub(:switch) { nil }
          @plugin.validate_allowed_switches.should eq nil
        end
      end
      
      context "with no switches specified" do
        before do
          @client = double
          @cmd = double
          class PluginValidateNoSwitchTest
            include Plugin
          end
          @plugin = PluginValidateNoSwitchTest.new 
          @plugin.client = @client
          @plugin.cmd = @cmd
        end
    
        after do
          AresMUSH.send(:remove_const, :PluginValidateNoSwitchTest)
        end
      
        it "should allow command if there is a switch" do
          @cmd.stub(:switch) { "foo" }
          @plugin.validate_allowed_switches.should eq nil
        end
      
        it "should allow command if there is no switch" do
          @cmd.stub(:switch) { nil }
          @plugin.validate_allowed_switches.should eq nil
        end
      end
    end
  end
end