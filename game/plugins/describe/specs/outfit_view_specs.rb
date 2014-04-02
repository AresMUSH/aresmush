require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe OutfitViewCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(OutfitViewCmd, "outfit name")
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that requires login"
      
      describe :check_outfit_exists do
        before do
          handler.stub(:name) { "name" }
        end
          
        it "should return OK if the outfit exists" do
          char.stub(:outfit).with("name") { "outfit" }
          handler.check_outfit_exists.should be_nil
        end
        
        it "should return an error if the outfit doesn't exist" do
          char.stub(:outfit).with("name") { nil }
          handler.check_outfit_exists.should eq 'describe.outfit_does_not_exist'
        end
      end
      
      describe :handle do
        it "should show the outfit" do
          handler.crack!
          char.stub(:outfit).with("Name") { "a desc" }
          BorderedDisplay.should_receive(:text).with("a desc", 'describe.outfit') { "formatted text" }
          client.stub(:emit).with("formatted text")
          handler.handle
        end
      end
    end
  end
end