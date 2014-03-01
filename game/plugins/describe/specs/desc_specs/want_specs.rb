require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
    describe DescCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(DescCmd, "desc name=description")
        SpecHelpers.stub_translate_for_testing        
      end  

      describe :want_command? do
        it "wants the desc command" do
          cmd.stub(:root_is?).with("desc") { true }
          handler.want_command?(client, cmd).should be_true
        end

        it "doesn't want another command" do
          cmd.stub(:root_is?).with("desc") { false }
          cmd.stub(:logged_in?) { true }
          handler.want_command?(client, cmd).should be_false
        end
      end            
   end     
  end
end