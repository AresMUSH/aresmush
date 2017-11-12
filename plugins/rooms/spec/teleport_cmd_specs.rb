module AresMUSH
  module Rooms
    describe TeleportCmd do
      
      before do
        @client = double
        @enactor = double
        @handler = TeleportCmd.new(@client, nil, @enactor)
        SpecHelpers.stub_translate_for_testing  
      end

      describe :find_destination do
        before do
          @room = double
          @room.stub(:name_upcase) { "SOMEWHERE" }
          @rooms = [ @room ]
          Room.stub(:all) { @rooms }
        end
        
        it "should find the room when the destination is a char" do
          @handler.stub(:destination) { "somewhere" }
          other_char = double
          other_char.stub(:room) { @room }
          ClassTargetFinder.should_receive(:find).with("somewhere", Character, @enactor) { FindResult.new(other_char, nil) }
          @handler.find_destination.should eq [@room]
        end
        
        it "should find the room when the destination is a room with an exact name match" do
          @handler.stub(:destination) { "somewhere" }
          ClassTargetFinder.should_receive(:find).with("somewhere", Character, @enactor) { FindResult.new(nil, "error") }
          ClassTargetFinder.should_receive(:find).with("somewhere", Room, @enactor) { FindResult.new(@room, nil) }
          @handler.find_destination.should eq [@room]
        end
      end
      
      describe :find_targets do
        it "should return the client if there's no name" do
          @handler.stub(:names) { [] }
          result = { :client => @client, :char => @enactor }
          targets = @handler.find_targets
          targets.should eq [ result ]
        end

        it "should return the matching char if there is one" do
          @handler.stub(:names) { [ "someone", "someone else" ] }
          other_char1 = double
          other_client1 = double
          other_char2 = double
          other_client2 = nil
          ClassTargetFinder.should_receive(:find).with("someone", Character, @enactor) { FindResult.new(other_char1, nil) }
          ClassTargetFinder.should_receive(:find).with("someone else", Character, @enactor) { FindResult.new(other_char2, nil) }
          
          Login.stub(:is_online?).with(other_char1) { true }
          Login.stub(:is_online?).with(other_char2) { false }
          Login.stub(:find_client).with(other_char1) { other_client1 }
          Login.stub(:find_client).with(other_char2) { nil }
          other_char1.stub(:client) { other_client1 }
          other_char2.stub(:client) { nil }
          result =  
            [ { :client => other_client1, :char => other_char1 },
              { :client => nil, :char => other_char2 } ]
          @handler.find_targets.should eq result
        end

        it "should return nil if nothing found" do
          @handler.stub(:names) { [ "someone" ] }
          ClassTargetFinder.should_receive(:find).with("someone", Character, @enactor) { FindResult.new(nil, "error") }
          @client.should_receive(:emit_failure).with('rooms.cant_find_that_to_teleport')
          @handler.find_targets.should eq []
        end
      end
      
      describe :handle do
        before do
          @handler.stub(:destination) { "Somewhere" }
        end
        
        context "teleporting self" do
          before do
            @dest = double
            @handler.stub(:find_destination) { [@dest] }
            @handler.stub(:find_targets) { [ {:client => @client, :char => @enactor } ] }
          end
          
          it "should go to the room" do
            Rooms.should_receive(:move_to).with(@client, @enactor, @dest)
            @handler.handle
          end
          
          it "should not emit to the client" do
            Rooms.stub(:move_to)
            @client.should_not_receive(:emit_ooc)
            @handler.handle
          end
        end  
        
        context "teleporting someone else" do
          before do
            @dest = double
            @other_char = double
            @other_client = double
            @enactor.stub(:name) { "Bob" }
            @handler.stub(:find_destination) { [@dest] }
            @handler.stub(:find_targets) { [ {:client => @other_client, :char => @other_char } ] }
          end
          
          it "should go to the room" do
            Rooms.should_receive(:move_to).with(@other_client, @other_char, @dest)
            @other_client.stub(:emit_ooc)
            @handler.handle
          end
          
          it "should tell the person they're being teleported" do
            Rooms.stub(:move_to)
            @other_client.should_receive(:emit_ooc).with('rooms.you_are_teleported')
            @handler.handle
          end
        end        
        
        context "destination not found" do
          before do
            other_char = double
            other_client = double
            @handler.stub(:find_destination) { [] }
            @handler.stub(:find_targets) { [ {:client => other_client, :char => other_char } ] }
            @client.stub(:emit_failure)
          end  
          
          it "should emit failure" do
            @client.should_receive(:emit_failure).with("rooms.invalid_teleport_destination")          
            @handler.handle
          end
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            @handler.handle
          end
        end
        
        context "targets not found" do          
          before do
            @handler.stub(:find_targets) { [] }
            @handler.stub(:find_destination) { [double] }
            @client.stub(:emit_failure)
          end  
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            @handler.handle
          end
        end
        
      end
    end
  end
end