require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe  
    describe LookCmd do
      include CommandTestHelper
      
      before do
        init_handler(LookCmd, "look something")
        SpecHelpers.stub_translate_for_testing        
      end        

      it "should set the target" do
        init_handler(LookCmd, "look Bob's Room")
        handler.crack!
        handler.target.should eq "Bob's Room"
      end
        
      it "should use here if there's no target" do
        init_handler(LookCmd, "look")
        handler.crack!
        handler.target.should eq "here"
      end        
    end
  end
end