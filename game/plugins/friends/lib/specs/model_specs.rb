module AresMUSH
  module Handles
    describe Character do
      
      describe :has_friended_char_or_handle? do
        before do
          @char = Character.new(name: "Bob")
          @other = Character.new(name: "Harry")
          @char.stub(:friends) { [] }
          @other.stub(:friends) { [] }
        end
        
        it "should return true if on character friends list" do
          @char.stub(:friends) { [ @other ] }
          @char.has_friended_char_or_handle?(@other).should be_true
        end
        
        it "should return true if on handle friends list" do
          @char.handle_friends = [ "@Star" ]
          @other.stub(:handle) { "@Star" }
          @char.has_friended_char_or_handle?(@other).should be_true
        end
        
        it "should return false if not a friend" do
          @char.has_friended_char_or_handle?(@other).should be_false
        end
      end
    end
  end
end
