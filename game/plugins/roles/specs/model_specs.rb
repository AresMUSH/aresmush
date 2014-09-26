module AresMUSH

  describe Character do
    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :has_role? do
      before do
        @char = Character.new
        @char.roles = [ "A" ]
      end
        
      it "should return true if the character has the role" do
        @char.has_role?("A").should be_true
      end
      
      it "should return false if they don't" do
        @char.has_role?("B").should be_false
      end
    end
    
    describe :has_any_role? do
      before do
        @char = Character.new
        @char.roles = [ "A", "B" ]
      end
      it "should return true if the character has a role in the list" do
        @char.has_any_role?([ "B", "C" ]).should be_true
      end
      
      it "should return false if they don't" do
        @char.has_any_role?([ "C", "D" ]).should be_false
      end
      
      it "should accept a single role" do
        @char.has_any_role?( "B" ).should be_true        
      end
    end
  end
end