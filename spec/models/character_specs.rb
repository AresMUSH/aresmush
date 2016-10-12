$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Character do
    before do
      SpecHelpers.stub_translate_for_testing
    end
    
    describe :found? do
      it "should return true if there is an existing char" do
        Character.stub(:find_one_by_name).with("Bob") { double }
        Character.found?("Bob").should be_true
      end
      
      it "should return false if no char exists" do
        Character.stub(:find_one_by_name).with("Bob") { false }
        Character.found?("Bob").should be_false
      end
    end 

    context "roles" do
      
      before do
        @char = Character.new
        @role_a = Role.new(name: "A")
        @role_b = Role.new(name: "B")
        
        Role.stub(:find_one_by_name).with("A") { @role_a }
        Role.stub(:find_one_by_name).with("B") { @role_b }
        Role.stub(:find_one_by_name).with("C") { double }
        Role.stub(:find_one_by_name).with("D") { double }
      end
    
      describe :has_role? do
        before do
          @char.stub(:roles) { [@role_a] }
        end
        
        it "should return true if the character has the role" do
          @char.has_role?("A").should be_true
        end

        it "should return false if they don't" do
          @char.has_role?("B").should be_false
        end

        it "should search by role class as well as name" do
          @char.has_role?(@role_a).should be_true
          @char.has_role?(@role_b).should be_false
        end
        
      end
    
      describe :has_any_role? do
        before do
          @char.stub(:roles) { [ @role_a, @role_b ] }
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
    
    describe :ooc_name do
      before do
        @char = Character.new(name: "Bob")
        @handle = Handle.new(name: "Star")
      end
      
      it "should display the name by itself" do
        @char.ooc_name.should eq "Bob"
      end
      

      it "should display a char with a public handle" do
        @char.stub(:handle) {@handle}
        @char.ooc_name.should eq "Bob (@Star)"
      end
      
      it "should display a char with a public handle and alias" do
        @char.stub(:handle) {@handle}
        @char.alias = "B"
        @char.ooc_name.should eq "Bob (@Star)"
      end
      
      it "should display public handle matching name" do
        @char.stub(:handle) {@handle}
        @char.name = "Star"
        @char.alias = "B"
        @char.ooc_name.should eq "Star (@Star)"
      end
    end
     
  end
end