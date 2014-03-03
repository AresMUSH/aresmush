require_relative "../../plugin_test_loader"

module AresMUSH
  module Who
    describe HideCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(HideCmd, "hide")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that doesn't allow args"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "hide" }
      end

      describe :handle do
        it "should toggle the hidden flag on" do
          char.should_receive(:hidden) { false }
          char.should_receive(:hidden=).with(true)
          client.should_receive(:emit_success).with('who.hide_enabled')
          handler.handle
        end
        
        it "should toggle the hidden flag off" do
          char.should_receive(:hidden) { true }
          char.should_receive(:hidden=).with(false)
          client.should_receive(:emit_success).with('who.hide_disabled')
          handler.handle
        end
      end
    end
  end
end