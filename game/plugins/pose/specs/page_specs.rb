require_relative "../../plugin_test_loader"

module AresMUSH
  module Pose
    describe PageCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(PageCmd, "page bob=something")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
    
      describe :handle do
        it "should send the message" do
          handler.handle
        end
      end
      
      describe :crack! do
        it "should crack a name and message" do
          init_handler(PageCmd, "page bob=something")
          handler.crack!
          handler.names = [ "bob" ]
          handler.message = "something"
        end
        
        it "should crack a list of multiple names" do
          init_handler(PageCmd, "page bob harvey=something")
          handler.crack!
          handler.names = [ "bob", "harvey" ]
          handler.message = "something"
        end
        
        it "should use the lastpaged if no name specified" do
          init_handler(PageCmd, "page something")
          char.stub(:last_paged) { ["bob", "harvey"] }
          handler.crack!
          handler.names = [ "bob", "harvey" ]
          handler.message = "something"
        end
      end
      
      
    end
  end
end