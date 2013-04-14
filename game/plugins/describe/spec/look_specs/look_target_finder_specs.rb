require_relative "../../../plugin_test_loader"

module AresMUSH
  module Describe
  
    describe LookTargetFinder do
      before do
        @model = mock
        @client = double(Client)
        AresMUSH::Locale.stub(:translate).with("object.here") { "here" }        
      end
      
      describe :find do
        it "should default to here if no args are given" do
          Rooms.should_receive(:find_visible_object).with("here", @client) { @model }
          LookTargetFinder.find(nil, @client).should eq @model
        end

        it "should look for the room target" do
          Rooms.should_receive(:find_visible_object).with("Bob", @client) { @model }
          args = mock
          args.stub(:target) { "Bob" }
          LookTargetFinder.find(args, @client).should eq @model
        end
      end
    end
  end
end