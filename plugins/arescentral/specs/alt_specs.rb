module AresMUSH
  module AresCentral
    describe AresCentral do
      before do
        @char1 = double
        @char2 = double
        @handle1 = double
        @handle2 = double
      end
      
      describe :is_alt? do
        it "should return false if either char is nil" do
          expect(AresCentral.is_alt?(@char1, nil)).to be false
          expect(AresCentral.is_alt?(nil, @char1)).to be false
        end
        
        it "should return true if char names are the same" do
          @char1.stub(:name) { "Bob" }
          @char2.stub(:name) { "Bob" }
          expect(AresCentral.is_alt?(@char1, @char2)).to be true
        end
        
        it "should return false if char names are different with no handles for either" do
          @char1.stub(:name) { "Bob" }
          @char2.stub(:name) { "Mary" }
          @char1.stub(:handle) { nil }
          @char2.stub(:handle) { nil }
          expect(AresCentral.is_alt?(@char1, @char2)).to be false
        end
        
        it "should return if char names are different with no handle for one" do
          @char1.stub(:name) { "Bob" }
          @char2.stub(:name) { "Mary" }
          @char1.stub(:handle) { @handle1 }
          @char2.stub(:handle) { nil }
          expect(AresCentral.is_alt?(@char1, @char2)).to be false
          expect(AresCentral.is_alt?(@char2, @char1)).to be false
        end
        
        it "should return true handles are same" do
          @char1.stub(:name) { "Bob" }
          @char2.stub(:name) { "Mary" }
          @char1.stub(:handle) { @handle1 }
          @char2.stub(:handle) { @handle2 }
          @handle1.stub(:name) { "CoolGuy" }
          @handle2.stub(:name) { "CoolGuy" }
          expect(AresCentral.is_alt?(@char1, @char2)).to be true
        end
      end
      
    end
  end
end
      