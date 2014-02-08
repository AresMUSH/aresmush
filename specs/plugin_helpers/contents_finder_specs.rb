$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe ContentsFinder do
    describe :contents do
      it "should aggregate the rooms exits and chars matching the location" do
        Character.should_receive(:find_by_location_id).with("123") { [ "a", "b" ] }
        Room.should_receive(:find_by_location_id).with("123") { [ "c", "d" ] }
        Exit.should_receive(:find_by_location_id).with("123"){ [ "e", "f" ] }
        ContentsFinder.find("123").should eq ["a", "b", "c", "d", "e", "f"]
      end
    end
  end
end