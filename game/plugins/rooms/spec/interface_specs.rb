require_relative "../../plugin_test_loader"

module AresMUSH
  module Rooms
    describe :find_visible_object do
      before do
        AresMUSH::Locale.stub(:translate).with("object.me") { "me" }
        AresMUSH::Locale.stub(:translate).with("object.here") { "here" }
        @client = mock
        @client.stub(:location) { "1" }        
      end
      
      it "should return the char for the me keword" do
        @client.stub(:char) { @char }
        Rooms.find_visible_object("me", @client).should eq @char
      end

      it "should return the char's location for the here keyword" do
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
    
    describe :chars do
      it "should return the list of chars in the room" do
        chars = ["A", "B"]
        Character.should_receive(:find).with({ "location" => "123" }) { chars }
        Rooms.chars("123").should eq chars
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
      it "should return both the chars and the exits" do
        chars = ["A", "B"]
        exits = ["C", "D"]
        Rooms.should_receive(:chars).with("123") { chars }
        Rooms.should_receive(:exits_from).with("123") { exits }
        Rooms.contents("123").should eq ["A", "B", "C", "D"]
      end
    end    
  end
end