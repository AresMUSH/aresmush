module AresMUSH
  module Friends
    describe Character do
      
      describe :has_friended_char_or_handle? do
        
        context "Game friends" do
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
        
          it "should return false if not a friend" do
            @char.has_friended_char_or_handle?(@other).should be_false
          end
        end
        
        context "Handle friends" do
          
          before do
            @char = Character.new(name: "Bob")
            @other = Character.new(name: "Harry")
            @char.stub(:friends) { [] }
            @other.stub(:friends) { [] }
            @handle = Handle.new(name: "BobHandle")
            @other_handle = Handle.new(name: "HarryHandle")
          end
          
          it "should return true if on handle friends list" do
            @char.stub(:handle) { @handle }
            @handle.stub(:friends) { [ "HarryHandle" ] }
            @other.stub(:handle) { @other_handle }
            
            @char.has_friended_char_or_handle?(@other).should be_true
          end
        
          it "should return false if this char has no handle" do
            @other.stub(:handle) { @other_handle }
            @char.has_friended_char_or_handle?(@other).should be_false          
          end
        
          it "should return false if other char has no handle" do
            @char.stub(:handle) { @handle }
            @handle.stub(:friends) { [ "HarryHandle" ] }
            @char.has_friended_char_or_handle?(@other).should be_false          
          end
          
          it "should return false if this char has no friends" do
            @char.stub(:handle) { @handle }
            @other.stub(:handle) { @other_handle }
            @char.has_friended_char_or_handle?(@other).should be_false          
          end
          
          
        end
      end
    end
  end
end
