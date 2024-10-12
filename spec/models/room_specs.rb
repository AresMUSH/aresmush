

require "aresmush"

module AresMUSH

  describe Room do
    
    before do
      @room = Room.new
      @client1 = double
      @client2 = double
      @client3 = double
      @char1 = double
      @char2 = double
      @char3 = double
      
      client_monitor = double
      allow(@char1).to receive(:room) { @room }
      allow(@char2).to receive(:room) { @room }
      allow(@char3).to receive(:room) { double }
    end
    
    describe :get_exit do
      it "should return exit if exit exists - case-insensitive" do
        exit1 = Exit.new(:name_upcase => "A",)
        exit2 = Exit.new(:name_upcase => "B")
        allow(@room).to receive(:exits) { [ exit1, exit2 ]}
        expect(@room.get_exit("a").name_upcase).to eq "A"
        expect(@room.get_exit("B").name_upcase).to eq "B"
        expect(@room.get_exit("C")).to eq nil
      end
      
      it "should return exit if exit exists even when alias exists" do
        exit1 = Exit.new(:name_upcase => "A", :alias_upcase => "B")
        exit2 = Exit.new(:name_upcase => "B")
        allow(@room).to receive(:exits) { [ exit1, exit2 ]}
        expect(@room.get_exit("B").name_upcase).to eq "B"
      end

      it "should return exit if alias exists" do
        exit1 = Exit.new(:name_upcase => "A", :alias_upcase => "C")
        exit2 = Exit.new(:name_upcase => "B")
        allow(@room).to receive(:exits) { [ exit1, exit2 ]}
        expect(@room.get_exit("C").name_upcase).to eq "A"
      end
    end
    
    describe :way_out do 
      it "should return the exit with name 'O' if it exists" do
        ex = double
        allow(@room).to receive(:get_exit).with("O") { ex }
        expect(@room.way_out).to eq ex
      end
      
      it "should return first exit if 'O' doesn't exist" do

        exit1 = Exit.new(:name_upcase => "A")
        exit2 = Exit.new(:name_upcase => "B")
        allow(@room).to receive(:exits) { [ exit1, exit2 ]}
        
        expect(@room.way_out.name_upcase).to eq "A"
      end
    end
    
    
  end
end
