module AresMUSH
  module Handles
    describe Character do      
      describe :ooc_name do
        before do
          @char = Character.new(name: "Bob")
        end
        
        it "should display the name by itself" do
          @char.ooc_name.should eq "Bob"
        end
        

        it "should display a char with a public handle" do
          @char.handle = "Star"
          @char.ooc_name.should eq "Bob (@Star)"
        end
        
        it "should display a char with a public handle and alias" do
          @char.handle = "Star"
          @char.alias = "B"
          @char.ooc_name.should eq "Bob (@Star)"
        end
        
        it "should display public handle matching name" do
          @char.handle = "Star"
          @char.name = "Star"
          @char.alias = "B"
          @char.ooc_name.should eq "Star (@Star)"
        end
      end
    end
  end
end
