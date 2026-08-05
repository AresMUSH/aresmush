module AresMUSH
    describe Character do
      before do
        @char1 = double
        @char2 = double
        @handle1 = double
        @handle2 = double
      end
      
      describe :is_alt? do
        it "should return false if either char is nil" do
          expect(Character.is_alt?(@char1, nil)).to be false
          expect(Character.is_alt?(nil, @char1)).to be false
        end
        
        it "should return true if char names are the same" do
          allow(@char1).to receive(:name) { "Bob" }
          allow(@char2).to receive(:name) { "Bob" }
          expect(Character.is_alt?(@char1, @char2)).to be true
        end
        
        it "should return false if char names are different with no handles for either" do
          allow(@char1).to receive(:name) { "Bob" }
          allow(@char2).to receive(:name) { "Mary" }
          allow(@char1).to receive(:handle) { nil }
          allow(@char2).to receive(:handle) { nil }
          expect(Character.is_alt?(@char1, @char2)).to be false
        end
        
        it "should return if char names are different with no handle for one" do
          allow(@char1).to receive(:name) { "Bob" }
          allow(@char2).to receive(:name) { "Mary" }
          allow(@char1).to receive(:handle) { @handle1 }
          allow(@char2).to receive(:handle) { nil }
          expect(Character.is_alt?(@char1, @char2)).to be false
          expect(Character.is_alt?(@char2, @char1)).to be false
        end
        
        it "should return true handles are same" do
          allow(@char1).to receive(:name) { "Bob" }
          allow(@char2).to receive(:name) { "Mary" }
          allow(@char1).to receive(:handle) { @handle1 }
          allow(@char2).to receive(:handle) { @handle2 }
          allow(@handle1).to receive(:name) { "CoolGuy" }
          allow(@handle2).to receive(:name) { "CoolGuy" }
          expect(Character.is_alt?(@char1, @char2)).to be true
        end
      end
      
    end
end
      