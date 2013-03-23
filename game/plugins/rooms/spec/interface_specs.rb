require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe :find_visible_object do
      before do
        AresMUSH::Locale.stub(:translate).with("rooms.me") { "me" }
        AresMUSH::Locale.stub(:translate).with("rooms.here") { "here" }
        @client = mock
        @client.stub(:location) { "1" }        
      end
      
      it "should return the player for the me keword" do
        @client.stub(:player) { @player }
        Rooms.find_visible_object("me", @client).should eq @player
      end

      it "should return the player's location for the here keyword" do
        location = mock
        Room.should_receive(:find_one).with("1") { location }
        Rooms.find_visible_object("here", @client).should eq location
      end
      
      it "should call ensure and notify and return the result for matching contents" do
        Rooms.should_receive(:contents).with("1") { ["A", "B"] }
        Room.should_receive(:notify_if_not_exatly_one) do |client, &block|
          client.should eq @client
          block.call
          "A"
        end
        Rooms.find_visible_object("A", @client).should eq "A"
      end
      
      it "should call ensure and notify and return nil if there's no match" do
        Rooms.should_receive(:contents).with("1") { ["A", "B"] }
        Room.should_receive(:notify_if_not_exatly_one) do |client, &block|
          client.should eq @client
          block.call
          nil
        end
        Rooms.find_visible_object("C", @client).should eq nil
      end
    end
    
    describe :players do
      it "should return the list of players in the room" do
        players = ["A", "B"]
        Player.should_receive(:find).with({ "location" => "123" }) { players }
        Rooms.players("123").should eq players
      end
    end
    
    describe :exits_from do
      it "should return the list of exits with this room as the source" do
        exits = ["A", "B"]
        Room.should_receive(:find).with({ "source" => "123" }) { exits }
        Rooms.exits_from("123").should eq exits
      end
    end
    
    describe :contents do
      it "should return both the players and the exits" do
        players = ["A", "B"]
        exits = ["C", "D"]
        Rooms.should_receive(:players).with("123") { players }
        Rooms.should_receive(:exits_from).with("123") { exits }
        Rooms.contents("123").should eq ["A", "B", "C", "D"]
      end
    end    
  end
end