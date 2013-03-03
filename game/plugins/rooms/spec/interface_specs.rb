require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe :find_all_visible do
      it "should return the player for the me keword" do
        client = mock
        player = mock
        client.stub(:player) { player }
        Rooms.find_all_visible("me", client).should eq [player]
      end

      # TODO - localize me
      # TODO - localize here

      it "should return the player's location for the here keyword" do
        player = { "location" => "1" }
        location = mock
        client = mock
        client.stub(:player) { player }
        Room.should_receive(:find_by_id).with("1") { location }
        Rooms.find_all_visible("here", client).should eq location
      end
    end
  end
end