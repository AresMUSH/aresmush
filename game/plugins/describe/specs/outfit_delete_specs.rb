require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe OutfitDeleteCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(OutfitDeleteCmd, "outfit/delete name")
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set and titlecase the name" do
          handler.crack!
          handler.name.should eq "Name"
        end
      end
      
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
        before do
          handler.crack!
          @outfits = double
          char.stub(:outfits) { @outfits }
        end
        
        it "should delete the outfit" do
          @outfits.should_receive(:delete).with("Name")
          char.should_receive(:save!)
          client.stub(:emit_success)
          handler.handle
        end
        
        it "should emit success" do
          @outfits.stub(:delete)
          char.stub(:save!)
          client.should_receive(:emit_success).with('describe.outfit_deleted')
          handler.handle
        end
      end
    end
  end
end