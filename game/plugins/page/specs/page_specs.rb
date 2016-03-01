require_relative "../../plugin_test_loader"

module AresMUSH
  module Page
    describe PageCmd do
      include CommandHandlerTestHelper
  
      before do
        init_handler(PageCmd, "page bob=something")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      
      describe :crack! do
        it "should crack a name and message" do
          init_handler(PageCmd, "page bob=something")
          handler.crack!
          handler.names.should eq [ "bob" ]
          handler.message.should eq "something"
        end
        
        it "should crack a list of multiple names" do
          init_handler(PageCmd, "page bob harvey=something")
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
        it "should use the lastpaged if no name specified" do
          init_handler(PageCmd, "page something")
          char.stub(:last_paged) { ["bob", "harvey"] }
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
        it "should use lastpaged for a message beginning with =" do
          init_handler(PageCmd, "page =something")
          char.stub(:last_paged) { ["bob", "harvey"] }
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
      end
      
      
    end
  end
end