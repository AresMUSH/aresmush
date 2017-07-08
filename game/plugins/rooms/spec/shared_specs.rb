module AresMUSH
  module Rooms
    describe Rooms do
      describe :open_exit do
        before do
          @source = double
          @dest = double
          @source.stub(:name) { "source" }
          @dest.stub(:name) { "dest" }
          SpecHelpers.stub_translate_for_testing
        end
      
        it "should return error if exit already exists." do
          @source.should_receive(:has_exit?).with("AE") { true }
          Exit.should_not_receive(:create)
          Rooms.open_exit("AE", @source, @dest).should eq "rooms.exit_already_exists"
        end
      
        it "should create the exit" do
          @source.stub(:has_exit?) { false }
          Exit.should_receive(:create).with( { :name => "AE", :source => @source, :dest => @dest } )
          Rooms.open_exit("AE", @source, @dest).should eq "rooms.exit_created"
        end
      end
    
      describe :emit_here_desc do
        it "should emit current room desc" do
          client = double
          char = double
          room = double
          template = double
          Describe.should_receive(:desc_template).with(room, char) { template }
          template.should_receive(:render) { "room desc" }
          char.stub(:room) { room }
          client.should_receive(:emit).with("room desc")
          Rooms.emit_here_desc(client, char)
        end
      end   
    end   
  end
end
