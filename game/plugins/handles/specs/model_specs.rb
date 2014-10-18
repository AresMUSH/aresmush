module AresMUSH
  module Handles
    describe Character do
      
      describe :can_see_handle do
        before do
          @char = Character.new(name: "Bob")
          @other = Character.new(name: "Harry")
          @char.stub(:is_friends_with?).with(@other) { false }
        end
        
        it "should return true if handle public" do
          @char.handle_privacy = Handles.privacy_public
          @char.handle_visible_to?(@other).should eq true
        end
        
        it "should return true if handle friends-only and a friend" do
          @char.handle_privacy = Handles.privacy_friends
          @char.stub(:is_friends_with?).with(@other) { true }
          @char.handle_visible_to?(@other).should eq true
        end
        
        it "should return false if handle friends-only and not a friend" do
          @char.handle_privacy = Handles.privacy_friends
          @char.handle_visible_to?(@other).should eq false
        end
        
        it "should return false if handle private" do
          @char.handle_privacy = Handles.privacy_private
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
          @char.handle = "Star"
          @char.handle_privacy = Handles.privacy_private
          @char.ooc_name.should eq "Bob"
        end

        it "should display a char with a public handle" do
          @char.handle = "Star"
          @char.handle_privacy = Handles.privacy_public
          @char.ooc_name.should eq "@Star (Bob)"
        end
        
        it "should display a char with a private handle and alias" do
          @char.handle = "Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_private
          @char.ooc_name.should eq "Bob (B)"
        end
        
        it "should display a char with a public handle and alias" do
          @char.handle = "Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_public
          @char.ooc_name.should eq "@Star (Bob, B)"
        end
        
        it "should display handle only char" do
          @char.handle = "Star"
          @char.alias = "B"
          @char.handle_privacy = Handles.privacy_public
          @char.handle_only = true
          @char.ooc_name.should eq "@Star"
        end
      end
    end
  end
end
