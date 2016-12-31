require_relative "../../plugin_test_loader"

module AresMUSH
  module Page
    describe PageCmd do
  
      before do
        @enactor = double
        SpecHelpers.stub_translate_for_testing
      end
            
      describe :crack! do
        it "should crack a name and message" do
          handler = PageCmd.new(@client, Command.new("page bob=something"), @enactor)
          handler.crack!
          handler.names.should eq [ "bob" ]
          handler.message.should eq "something"
        end
        
        it "should crack a list of multiple names" do
          handler = PageCmd.new(@client, Command.new("page bob harvey=something"), @enactor)
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
        it "should use the lastpaged if no name specified" do
          handler = PageCmd.new(@client, Command.new("page something"), @enactor)
          @enactor.stub(:last_paged) { ["bob", "harvey"] }
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
        it "should use lastpaged for a message beginning with =" do
          handler = PageCmd.new(@client, Command.new("page =something"), @enactor)
          @enactor.stub(:last_paged) { ["bob", "harvey"] }
          handler.crack!
          handler.names.should eq [ "bob", "harvey" ]
          handler.message.should eq "something"
        end
        
      end
      
      
    end
  end
end