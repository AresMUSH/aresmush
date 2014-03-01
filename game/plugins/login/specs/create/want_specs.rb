require_relative "../../../plugin_test_loader"

module AresMUSH
  module Login
    describe CreateCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(CreateCmd, "create Bob bobpassword")
        SpecHelpers.stub_translate_for_testing        
      end
      
      describe :want_command? do
        it "should want the create command" do
          cmd.stub(:root_is?).with("create") { true }
          handler.want_command?(client, cmd).should eq true
        end

        it "should not want a different command" do
          cmd.stub(:root_is?).with("create") { false }
          handler.want_command?(client, cmd).should eq false
        end
      end
    end
  end
end

