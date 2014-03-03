require_relative "../../plugin_test_loader"

module AresMUSH
  module Describe
    
    describe ShortdescCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(ShortdescCmd, "shortdesc description")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "shortdesc" }
      end
      
      describe :crack do
        it "should set the desc based on the args" do
          init_handler(ShortdescCmd, "shortdesc a desc")
          handler.crack!
          handler.desc.should eq "a desc"
        end
      end
            
      describe :validate_syntax do
        it "should make sure the desc is specified" do
          handler.stub(:desc) { nil }
          handler.validate_syntax.should eq 'describe.invalid_shortdesc_syntax'
        end
        
        it "should accept the command if everything is ok" do
          handler.stub(:desc) { "a desc" }
          handler.validate_syntax.should be_nil
        end
      end
      
      describe :handle do
        before do
          handler.crack!
          char.stub(:shortdesc=)
          client.stub(:emit_success)
          char.stub(:save!)
        end
        it "should set the shortdesc" do
          char.should_receive(:shortdesc=).with("description")
          handler.handle
        end
        
        it "should emit success" do
          client.should_receive(:emit_success).with("describe.shortdesc_set")
          handler.handle
        end
          
        it "should save the character" do
          char.should_receive(:save!)
          handler.handle
        end
      end
    end
  end
end