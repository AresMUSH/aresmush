require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe WearCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(WearCmd, "wear something")
        SpecHelpers.stub_translate_for_testing        
      end        

      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"

      describe :want_command? do
        it "should want the wear command" do
          handler.want_command?(client, cmd).should be_true
        end
        
        it "should not want another command" do
          cmd.stub(:root_is?).with("wear") { false }
          handler.want_command?(client, cmd).should be_false
        end
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
      
      describe :validate_outfits_exist do
        it "should make sure some descs are specified" do
          handler.stub(:names) { nil }
          handler.validate_outfits_exist.should eq 'describe.invalid_wear_syntax'
        end
        
        it "should be OK if all the descs exist" do
          char.stub(:outfits) { { "a" => "a desc", "b" => "b desc" } }
          handler.stub(:names) { [ "a", "b" ] }
          handler.validate_outfits_exist.should be_nil
        end

        it "should fail if one of the descs doesn't exist" do
          char.stub(:outfits) { { "a" => "a desc", "b" => "b desc" } }
          handler.stub(:names) { [ "a", "c", "b" ] }
          handler.validate_outfits_exist.should eq "describe.outfit_does_not_exist"
        end
      end
      
      describe :handle do
        before do
          char.stub(:outfits) { { "a" => "a desc", "b" => " b desc" } }
          handler.stub(:names) { [ "a", "b" ] }
        end
        
        it "should set the character description to all the outfits" do
          char.should_receive(:description=).with("a desc b desc")
          client.stub(:emit_success)
          handler.handle
        end
        
        it "should emit success" do
          char.stub(:description=)
          client.should_receive(:emit_success).with('describe.outfits_worn')
          handler.handle
        end
      end
    end
  end
end