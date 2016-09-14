module AresMUSH
  module Handles
    describe Character, :dbtest => true do
      include GameTestHelper
      
      before do
        stub_game_master
        game.stub(:welcome_room) { nil }
        game.stub(:ooc_room) { nil }
      end
      
      describe :find_by_handle do
        it "should find a char with that handle" do
          using_test_db do
            char = Character.create(name: "Test", handle: "@Bob")
            Character.find_by_handle("@Bob").should eq [ char ]
          end
        end
        
        it "should not find a char if none exists" do
          using_test_db do 
            Character.find_by_handle("@Foo").should eq []
          end
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
          @char.handle = "@Star"
          @char.ooc_name.should eq "Bob (@Star)"
        end
        
        it "should display a char with a public handle and alias" do
          @char.handle = "@Star"
          @char.alias = "B"
          @char.ooc_name.should eq "Bob (@Star)"
        end
        
        it "should display public handle matching name" do
          @char.handle = "@Star"
          @char.name = "Star"
          @char.alias = "B"
          @char.ooc_name.should eq "Star (@Star)"
        end
      end
    end
  end
end
