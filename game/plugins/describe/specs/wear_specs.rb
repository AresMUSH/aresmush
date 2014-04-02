require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe WearCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(WearCmd, "wear something")
        
        char.stub(:outfit).with("a") { "a desc" }
        char.stub(:outfit).with("b") { "b desc" }
        
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "wear" }
      end
      
      describe :crack! do
        it "should set the names to nil if none are specified" do
          init_handler(WearCmd, "wear")
          handler.crack!
          handler.names.should be_nil
        end
        
        it "should set and titlecase the list of names" do
          init_handler(WearCmd, "wear a desc,   BbB,C   ")
          handler.crack!
          handler.names.should eq [ "A Desc", "Bbb", "C" ]
        end
      end
      
      describe :check_outfits_exist do
        it "should make sure some descs are specified" do
          handler.stub(:names) { nil }
          handler.check_outfits_exist.should eq 'dispatcher.invalid_syntax'
        end
        
        it "should be OK if all the descs exist" do
          handler.stub(:names) { [ "a", "b" ] }
          handler.check_outfits_exist.should be_nil
        end

        it "should fail if one of the descs doesn't exist" do
          char.stub(:outfit).with("c") { nil }
          
          handler.stub(:names) { [ "a", "c" ] }
          handler.check_outfits_exist.should eq "describe.outfit_does_not_exist"
        end
      end
      
      describe :handle do
        before do
          handler.stub(:names) { [ "a", "b" ] }
        end
        
        it "should set the character description to all the outfits" do
          Describe.should_receive(:set_desc).with(char, "a descb desc")
          client.stub(:emit_success)
          handler.handle
        end
        
        it "should emit success" do
          Describe.stub(:set_desc)
          client.should_receive(:emit_success).with('describe.outfits_worn')
          handler.handle
        end
      end
    end
  end
end