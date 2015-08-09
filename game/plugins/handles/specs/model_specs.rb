module AresMUSH
  module Handles
    describe Character, :dbtest => true do
      include GameTestHelper
      
      before do
        stub_game_master
        game.stub(:welcome_room) { nil }
        game.stub(:ooc_room) { nil }
      end
      
      describe :find_by_handle do
        it "should find a char with that handle" do
          using_test_db do
            char = Character.create(name: "Test", handle: "@Bob")
            Character.find_by_handle("@Bob").should eq [ char ]
          end
        end
        
        it "should not find a char if none exists" do
          using_test_db do 
            Character.find_by_handle("@Foo").should eq []
          end
        end
      end
      
      describe :can_see_handle do
        before do
          @char = Character.new(name: "Bob")
          @other = Character.new(name: "Harry")
          @char.stub(:has_friended_char_or_handle?).with(@other) { false }
        end
        
        it "should return true if handle public" do
          @char.handle_privacy = Handles.privacy_public
          @char.handle_visible_to?(@other).should eq true
        end
        
        it "should return true if handle friends-only and a friend" do
          @char.handle_privacy = Handles.privacy_friends
          @char.stub(:has_friended_char_or_handle?).with(@other) { true }
          @char.handle_visible_to?(@other).should eq true
        end
        
        it "should return false if handle friends-only and not a friend" do
          @char.handle_privacy = Handles.privacy_friends
          @char.handle_visible_to?(@other).should eq false
        end
        
        it "should return false if handle private" do
          @char.handle_privacy = Handles.privacy_admin
          @char.handle_visible_to?(@other).should eq false
        end
      end
      
      
      describe :ooc_name do
        before do
          @char = Character.new(name: "Bob")
        end
        
        it "should display the name by itself" do
          @char.ooc_name.should eq "Bob"
        end
        
        it "should display a char with a private handle" do
          @char.handle = "@Star"
          @char.handle_privacy = Handles.privacy_admin
          @char.ooc_name.should eq "Bob"
        end

        it "should display a char with a public handle" do
          @char.handle = "@Star"
          @char.handle_privacy = Handles.privacy_public
          
          # TODO - Delete this if it's going to stay this way.
          #@char.ooc_name.should eq "@Star (Bob)"
          @char.ooc_name.should eq "Bob (@Star)"
          
        end
        
        it "should display a char with a private handle and alias" do
          @char.handle = "@Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_admin
          # TODO - Delete this if it's going to stay this way.
          #@char.ooc_name.should eq "Bob (B)"
          @char.ooc_name.should eq "Bob"
        end
        
        it "should display a char with a public handle and alias" do
          @char.handle = "@Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_public
          # TODO - Delete this if it's going to stay this way.
          #@char.ooc_name.should eq "@Star (Bob, B)"
          @char.ooc_name.should eq "Bob (@Star)"
        end
        
        it "should display public handle matching name" do
          @char.handle = "@Star"
          @char.name = "Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_public
          # TODO - Delete this if it's going to stay this way.
          # @char.ooc_name.should eq "@Star (B)"
          @char.ooc_name.should eq "Star (@Star)"
        end
      end
    end
  end
end
