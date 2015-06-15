$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Character do
    include GameTestHelper
    
    
    before do
      SpecHelpers.stub_translate_for_testing
      stub_game_master
      game.stub(:welcome_room) { nil }
      game.stub(:ooc_room) { nil }
    end
    
    describe :found? do
      it "should return true if there is an existing char" do
        Character.stub(:find_by_name).with("Bob") { double }
        Character.found?("Bob").should be_true
      end
      
      it "should return false if no char exists" do
        Character.stub(:find_by_name).with("Bob") { nil }
        Character.found?("Bob").should be_false
      end
    end  
    
    describe :create_a_bazillion_things do 
      it "should not die" do
        router = double
        router.stub(:is_master?) { true }
        Global.stub(:api_router) { router }
        using_test_db do 
        last = nil
        1000.times.each do |n|
          Room.create(name: "Room #{n}")
          Exit.create(name: "Exit #{n}")
          Character.create(name: "Char #{n}")
        end
      end
      end
    end
  end
end