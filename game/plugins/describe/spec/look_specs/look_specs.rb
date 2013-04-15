require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe Look do
      before do
        container = double(Container)
        container.stub(:plugin_manager) { @plugin_manager }
        @plugin_manager = double(PluginManager)
        @client = double(Client)
        @look = Look.new(container)
        AresMUSH::Locale.stub(:translate).with("object.here") { "here" }        
      end
      
      describe :want_anon_command? do
        it "doesn't want any commands" do
          cmd = mock
          @look.want_anon_command?(cmd).should be_false
        end
      end

      describe :want_command? do
        it "wants the look command" do
          cmd = mock
          cmd.stub(:root_is?).with("look") { true }
          @look.want_command?(cmd).should be_true
        end

        it "doesn't want another command" do
          cmd = mock
          cmd.stub(:root_is?).with("look") { false }
          @look.want_command?(cmd).should be_false
        end
      end
      
      describe :on_command do
        before do
          @cmd = double(Command)
          @args = mock
          @args.stub(:target) { "target" }
          LookCmdCracker.stub(:crack) { @args }
        end
        
        it "should crack the args" do
          LookCmdCracker.should_receive(:crack).with(@cmd)
          # Short-circuit the rest of the command
          VisibleTargetFinder.stub(:find) { nil }
          @look.on_command(@client, @cmd)
        end
        
        it "should look for the target or here by default" do
          VisibleTargetFinder.should_receive(:find).with("target", @client, "here") { nil }
          @look.on_command(@client, @cmd)
        end
        
        it "should not handle the command if the target is not found" do
          VisibleTargetFinder.stub(:find) { nil }
          LookCmdHandler.should_not_receive(:handle)
          @look.on_command(@client, @cmd)
        end
        
        it "should call the command handler" do
          model = mock
          iface = double(DescFunctions)
          VisibleTargetFinder.stub(:find) { model }
          Describe.stub(:interface) { iface }
          LookCmdHandler.should_receive(:handle).with(iface, model, @client)
          @look.on_command(@client, @cmd)
        end
      end
    end
  end
end