$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

require "aresmush"

module AresMUSH

  describe Character do
    before do
      stub_translate_for_testing
    end
    
    describe :find_any_by_name do 
      it "should return nothing if no name specified" do
        expect(Character.find_any_by_name(nil)).to eq []
      end
      
      it "should find a result by db search" do
        found = double
        allow(Character).to receive(:find) { found }
        allow(found).to receive(:union) { [found] }
        expect(Character.find_any_by_name("name")).to eq [found]
      end
      
      it "should search partial name match if no exact match found" do
        found = double
        char1 = double
        allow(Character).to receive(:find) { found }
        allow(found).to receive(:union) { [] }
        allow(Character).to receive(:all) { [char1] }
        allow(char1).to receive(:name_upcase) { "BOB" }
        expect(Character.find_any_by_name("bo")).to eq [char1]
      end
      
      it "should only count partial name match if unambiguous match found" do
        found = double
        char1 = double
        char2 = double
        allow(Character).to receive(:find) { found }
        allow(found).to receive(:union) { [] }
        allow(Character).to receive(:all) { [char1, char2] }
        allow(char1).to receive(:name_upcase) { "BOB" }
        allow(char2).to receive(:name_upcase) { "BARB" }
        expect(Character.find_any_by_name("b")).to eq []
      end
      
      it "should return empty if no match found" do
        found = double
        char1 = double
        allow(Character).to receive(:find) { found }
        allow(found).to receive(:union) { [] }
        allow(Character).to receive(:all) { [char1] }
        allow(char1).to receive(:name_upcase) { "BOB" }
        expect(Character.find_any_by_name("x")).to eq []
      end
    end
    
    describe :found? do
      it "should return true if there is an existing char" do
        allow(Character).to receive(:find_one_by_name).with("Bob") { double }
        expect(Character.found?("Bob")).to be true
      end
      
      it "should return false if no char exists" do
        allow(Character).to receive(:find_one_by_name).with("Bob") { nil }
        expect(Character.found?("Bob")).to be false
      end
    end 

    context "roles" do
      
      before do
        @char = Character.new
        @role_a = Role.new(name: "A")
        @role_b = Role.new(name: "B")
        
        allow(Role).to receive(:find_one_by_name).with("A") { @role_a }
        allow(Role).to receive(:find_one_by_name).with("B") { @role_b }
        allow(Role).to receive(:find_one_by_name).with("C") { double }
        allow(Role).to receive(:find_one_by_name).with("D") { double }
      end
    
      describe :has_role? do
        before do
          allow(@char).to receive(:roles) { [@role_a] }
        end
        
        it "should return true if the character has the role" do
          expect(@char.has_role?("A")).to be true
        end

        it "should return false if they don't" do
          expect(@char.has_role?("B")).to be false
        end

        it "should search by role class as well as name" do
          expect(@char.has_role?(@role_a)).to be true
          expect(@char.has_role?(@role_b)).to be false
        end
        
      end
    
      describe :has_any_role? do
        before do
          allow(@char).to receive(:roles) { [ @role_a, @role_b ] }
        end
        it "should return true if the character has a role in the list" do
          expect(@char.has_any_role?([ "B", "C" ])).to be true
        end
      
        it "should return false if they don't" do
          expect(@char.has_any_role?([ "C", "D" ])).to be false
        end
      
        it "should accept a single role" do
          expect(@char.has_any_role?( "B" )).to be true        
        end
      end
    
    end
    
    describe :ooc_name do
      before do
        @char = Character.new(name: "Bob")
        @handle = Handle.new(name: "Star")
      end
      
      it "should display the name by itself" do
        expect(@char.ooc_name).to eq "Bob"
      end
      

      it "should display a char with a public handle" do
        allow(@char).to receive(:handle) {@handle}
        expect(@char.ooc_name).to eq "Bob (@Star)"
      end
      
      it "should display a char with a public handle and alias" do
        allow(@char).to receive(:handle) {@handle}
        @char.alias = "B"
        expect(@char.ooc_name).to eq "Bob (@Star)"
      end
      
      it "should display public handle matching name" do
        allow(@char).to receive(:handle) {@handle}
        @char.name = "Star"
        @char.alias = "B"
        expect(@char.ooc_name).to eq "Star (@Star)"
      end
    end
     
  end
end
