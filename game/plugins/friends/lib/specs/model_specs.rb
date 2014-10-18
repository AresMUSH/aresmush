module AresMUSH
  module Handles
    describe Character do
      
      describe :is_friends_with do
        before do
          @char = Character.new(name: "Bob")
          @other = Character.new(name: "Harry")
          @char.stub(:friends) { [] }
        end
        
        it "should return true if on character friends list" do
          @char.stub(:friends) { [ @other ] }
          @char.is_friends_with?(@other).should be_true
        end
        
        it "should return true if on handle friends list" do
          @char.handle_friends = [ "@Star" ]
          @other.stub(:handle) { "@Star" }
          @char.is_friends_with?(@other).should be_true
        end
        
        it "should return false if not a friend" do
          @char.is_friends_with?(@other).should be_false
        end
      end
    end
  end
end
