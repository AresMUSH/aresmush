module AresMUSH
  module Rooms
    describe TeleportCmd do
      
      before do
        @client = double
        @enactor = double
        @handler = TeleportCmd.new(@client, nil, @enactor)
        stub_translate_for_testing  
      end

      
      describe :find_targets do
        it "should return the client if there's no name" do
          allow(@handler).to receive(:names) { [] }
          result = { :client => @client, :char => @enactor }
          targets = @handler.find_targets
          expect(targets).to eq [ result ]
        end

        it "should return the matching char if there is one" do
          allow(@handler).to receive(:names) { [ "someone", "someone else" ] }
          other_char1 = double
          other_client1 = double
          other_char2 = double
          other_client2 = nil
          expect(ClassTargetFinder).to receive(:find).with("someone", Character, @enactor) { FindResult.new(other_char1, nil) }
          expect(ClassTargetFinder).to receive(:find).with("someone else", Character, @enactor) { FindResult.new(other_char2, nil) }
          
          allow(Login).to receive(:is_online?).with(other_char1) { true }
          allow(Login).to receive(:is_online?).with(other_char2) { false }
          allow(Login).to receive(:find_client).with(other_char1) { other_client1 }
          allow(Login).to receive(:find_client).with(other_char2) { nil }
          allow(other_char1).to receive(:client) { other_client1 }
          allow(other_char2).to receive(:client) { nil }
          result =  
            [ { :client => other_client1, :char => other_char1 },
              { :client => nil, :char => other_char2 } ]
          expect(@handler.find_targets).to eq result
        end

        it "should return nil if nothing found" do
          allow(@handler).to receive(:names) { [ "someone" ] }
          expect(ClassTargetFinder).to receive(:find).with("someone", Character, @enactor) { FindResult.new(nil, "error") }
          expect(@client).to receive(:emit_failure).with('rooms.cant_find_that_to_teleport')
          expect(@handler.find_targets).to eq []
        end
      end
      
      describe :handle do
        before do
          allow(@handler).to receive(:destination) { "Somewhere" }
        end
        
        context "teleporting self" do
          before do
            @dest = double
            allow(Rooms).to receive(:find_destination) { [@dest] }
            allow(@handler).to receive(:find_targets) { [ {:client => @client, :char => @enactor } ] }
            allow(@dest).to receive(:scene) { nil }
          end
          
          it "should go to the room" do
            expect(Rooms).to receive(:move_to).with(@client, @enactor, @dest)
            @handler.handle
          end
          
          it "should not emit to the client" do
            allow(Rooms).to receive(:move_to)
            expect(@client).to_not receive(:emit_ooc)
            @handler.handle
          end
        end  
        
        context "teleporting someone else" do
          before do
            @dest = double
            @other_char = double
            @other_client = double
            allow(@dest).to receive(:scene) { nil }
            allow(@enactor).to receive(:name) { "Bob" }
            allow(Rooms).to receive(:find_destination) { [@dest] }
            allow(@handler).to receive(:find_targets) { [ {:client => @other_client, :char => @other_char } ] }
          end
          
          it "should go to the room" do
            expect(Rooms).to receive(:move_to).with(@other_client, @other_char, @dest)
            allow(@other_client).to receive(:emit_ooc)
            @handler.handle
          end
          
          it "should tell the person they're being teleported" do
            allow(Rooms).to receive(:move_to)
            expect(@other_client).to receive(:emit_ooc).with('rooms.you_are_teleported')
            @handler.handle
          end
        end        
        
        context "destination not found" do
          before do
            other_char = double
            other_client = double
            room1 = double
            allow(room1).to receive(:name_upcase) { "ROOM1" }
            allow(Rooms).to receive(:find_destination) { [] }
            allow(@handler).to receive(:find_targets) { [ {:client => other_client, :char => other_char } ] }
            allow(Room).to receive(:all) { [ room1 ]}
            allow(@client).to receive(:emit_failure)
          end  
          
          it "should emit failure" do
            expect(@client).to receive(:emit_failure).with("rooms.invalid_teleport_destination")          
            @handler.handle
          end
          
          it "should not go anywhere" do
            expect(Rooms).to_not receive(:move_to)
            @handler.handle
          end
        end
        
        context "targets not found" do          
          before do
            @dest = double
            allow(@handler).to receive(:find_targets) { [] }
            allow(Rooms).to receive(:find_destination) { [@dest] }
            allow(@dest).to receive(:scene) { nil }
            allow(@client).to receive(:emit_failure)
          end  
          
          it "should not go anywhere" do
            expect(Rooms).to_not receive(:move_to)
            @handler.handle
          end
        end
         
        context "teleporting into private room should fail if not allowed to read scene" do
          before do
            @dest = double
            @scene = double
            allow(Rooms).to receive(:find_destination) { [@dest] }
            allow(@handler).to receive(:find_targets) { [ {:client => @client, :char => @enactor } ] }
            allow(@scene).to receive(:owner) { double }
            allow(@dest).to receive(:scene) { @scene }
            allow(Scenes).to receive(:can_read_scene?).with(@enactor, @scene) { false }
            allow(@dest).to receive(:owner) { nil }
          end
          
          it "should not go anywhere" do
            expect(@client).to receive(:emit_failure)
            expect(Rooms).to_not receive(:move_to)
            @handler.handle
          end
        end  
        
        context "teleporting into private room should succeed if allowed to read scene" do
          before do
            @dest = double
            @scene = double
            allow(Rooms).to receive(:find_destination) { [@dest] }
            allow(@handler).to receive(:find_targets) { [ {:client => @client, :char => @enactor } ] }
            allow(@scene).to receive(:owner) { double }
            allow(@dest).to receive(:scene) { @scene }
            allow(Scenes).to receive(:can_read_scene?).with(@enactor, @scene) { true }
            allow(@dest).to receive(:owner) { nil }
          end
          
          it "should go to the room" do
            expect(Rooms).to receive(:move_to).with(@client, @enactor, @dest)
            @handler.handle
          end
        end  
        
      end
    end
  end
end
