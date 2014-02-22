require_relative "../../../plugin_test_loader"

module AresMUSH
  module Manage
    describe LoadCmd do
      include CommandTestHelper
  
      before do
        init_handler(LoadCmd, "load foo")
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :crack! do
        it "should set the load target" do          
          handler.crack!
          handler.load_target.should eq 'foo'
        end
      end
    end
  end
end