require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe OutfitListCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(OutfitListCmd, "outfits")
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that requires login"
      
      describe :handle do
        before do
          @outfits = { "a" => "a desc", "b" => "b desc" }
          char.stub(:outfits) { @outfits }
        end
        
        it "should list the outfits" do
          BorderedDisplay.should_receive(:list).with(["a", "b"], 'describe.your_outfits') { "formatted list" }
          client.stub(:emit).with("formatted list")
          handler.handle
        end
      end
    end
  end
end