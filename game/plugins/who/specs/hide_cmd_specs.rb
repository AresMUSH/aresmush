require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe HideCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(HideCmd, "hide")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that requires login"

      describe :handle do
        it "should toggle the hidden flag on" do
          init_handler(HideCmd, "hide")
          char.should_receive(:hidden=).with(true)
          client.should_receive(:emit_success).with('who.hide_enabled')
          handler.handle
        end
        
        it "should toggle the hidden flag off" do
          init_handler(HideCmd, "unhide")
          char.should_receive(:hidden=).with(false)
          client.should_receive(:emit_success).with('who.hide_disabled')
          handler.handle
        end
      end
    end
  end
end