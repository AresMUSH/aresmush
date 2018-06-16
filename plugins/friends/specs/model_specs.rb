module AresMUSH
  module Friends
    describe Character do
      
      describe :has_friended_char_or_handle? do
        
        context "Game friends" do
          before do
            @char = Character.new(name: "Bob")
            @other = Character.new(name: "Harry")
            allow(@char).to receive(:friends) { [] }
            allow(@other).to receive(:friends) { [] }
          end
        
          it "should return true if on character friends list" do
            allow(@char).to receive(:friends) { [ @other ] }
            expect(@char.has_friended_char_or_handle?(@other)).to be true
          end
        
          it "should return false if not a friend" do
            expect(@char.has_friended_char_or_handle?(@other)).to be false
          end
        end
        
        context "Handle friends" do
          
          before do
            @char = Character.new(name: "Bob")
            @other = Character.new(name: "Harry")
            allow(@char).to receive(:friends) { [] }
            allow(@other).to receive(:friends) { [] }
            @handle = Handle.new(name: "BobHandle")
            @other_handle = Handle.new(name: "HarryHandle")
          end
          
          it "should return true if on handle friends list" do
            allow(@char).to receive(:handle) { @handle }
            allow(@handle).to receive(:friends) { [ "HarryHandle" ] }
            allow(@other).to receive(:handle) { @other_handle }
            
            expect(@char.has_friended_char_or_handle?(@other)).to be true
          end
        
          it "should return false if this char has no handle" do
            allow(@other).to receive(:handle) { @other_handle }
            expect(@char.has_friended_char_or_handle?(@other)).to be false          
          end
        
          it "should return false if other char has no handle" do
            allow(@char).to receive(:handle) { @handle }
            allow(@handle).to receive(:friends) { [ "HarryHandle" ] }
            expect(@char.has_friended_char_or_handle?(@other)).to be false          
          end
          
          it "should return false if this char has no friends" do
            allow(@char).to receive(:handle) { @handle }
            allow(@other).to receive(:handle) { @other_handle }
            expect(@char.has_friended_char_or_handle?(@other)).to be false          
          end
          
          
        end
      end
    end
  end
end
