require_relative "../../plugin_test_loader"

module AresMUSH
  module HelpSystem
    describe HelpListCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(HelpListCmd, "help")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      
      describe :crack! do
        it "should find the category based on the root" do
          HelpSystem.stub(:category_for_command).with("help") { "cat" }
          handler.crack!
          handler.category.should eq "cat"
        end        
      end  
     
      describe :handle do  
        # Entirely too much of a pain to test, and easy enough to visualize.
      end
    end
  end
end