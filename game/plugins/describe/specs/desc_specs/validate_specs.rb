require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe

    describe DescCmd do
      include CommandTestHelper
      
      before do
        init_handler(DescCmd, "desc name=description")
        SpecHelpers.stub_translate_for_testing        
      end  
    
      describe :validate_syntax do
        it "should make sure the target is specified" do
          handler.stub(:target) { nil }
          handler.stub(:desc) { "a desc" }
          handler.validate_syntax.should eq 'describe.invalid_desc_syntax'
        end
        
        it "should make sure the desc is specified" do
          handler.stub(:target) { "something" }
          handler.stub(:desc) { nil }
          handler.validate_syntax.should eq 'describe.invalid_desc_syntax'
        end
        
        it "should accept the command if everything is ok" do
          handler.stub(:target) { "something" }
          handler.stub(:desc) { "a desc" }
          handler.validate_syntax.should be_nil
        end
      end
    end     
  end
end