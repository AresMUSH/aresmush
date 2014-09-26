$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  describe Room do
    
    before do
      @room = Room.new
    end
    
    describe :set_upcase_name do
      it "should set the uppercase name on save" do
        using_test_db do
          @room.name = "test"
          @room.save!
          @room.name_upcase.should eq "TEST"
        end
      end
      
      it "should set the uppercase alias on save" do
        using_test_db do
          @room.alias = "test"
          @room.save!
          @room.alias_upcase.should eq "TEST"
        end
      end
    end
    
    describe :find_by_name do
      it "should find by name upcase" do
        using_test_db do
          @room.name = "test"
          @room.save!
          Room.find_by_name("TeSt").should eq @room
        end
      end
    end
    
    describe :find_all_by_name do
      it "should find many by name upcase" do
        using_test_db do
          @room.name = "test"
          @room.save!
          
          room2 = Room.create(name: "test")
          
          Room.find_all_by_name("TeSt").should eq [ @room, room2 ]
        end
      end
    end
    
  end
end