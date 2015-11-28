require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe OutfitSetCmd do
      include CommandHandlerTestHelper
      
      before do
        init_handler(OutfitSetCmd, "outfit/set name=desc")
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should set the desc" do
          handler.crack!
          handler.desc.should eq "desc"
        end

        it "should set and titlecase the name" do
          init_handler(OutfitSetCmd, "outfit/set   bBbC   =desc")
          handler.crack!
          handler.name.should eq "Bbbc"
        end
      end
      
      describe :handle do
        before do
          handler.crack!
          @outfits = double
          char.stub(:outfits) { @outfits }
        end
        
        it "should set the outfit" do
          @outfits.should_receive(:[]=).with("Name", "desc")
          char.should_receive(:save!)
          client.stub(:emit_success)
          handler.handle
        end
        
        it "should emit success" do
          @outfits.stub(:[]=)
          char.stub(:save!)
          client.should_receive(:emit_success).with('describe.outfit_set')
          handler.handle
        end
      end
    end
  end
end