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
        Character.stub(:find_one_by_name).with("Bob") { nil }
        Character.found?("Bob").should be_false
      end
    end 
    
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