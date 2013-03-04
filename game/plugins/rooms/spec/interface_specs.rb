require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe :find_visible_object do
      before do
        AresMUSH::Locale.stub(:translate).with("rooms.me") { "me" }
        AresMUSH::Locale.stub(:translate).with("rooms.here") { "here" }
      end
      
      it "should return the player for the me keword" do
        client = mock
        player = mock
        client.stub(:player) { player }
        Rooms.find_visible_object("me", client).should eq player
      end

      it "should return the player's location for the here keyword" do
        player = { "location" => "1" }
        location = mock
        client = mock
        client.stub(:player) { player }
        Room.should_receive(:find_one_and_notify).with("1", client) { location }
        Rooms.find_visible_object("here", client).should eq location
      end
    end
  end
end