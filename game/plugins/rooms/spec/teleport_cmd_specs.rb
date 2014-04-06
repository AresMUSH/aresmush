module AresMUSH
  module Rooms
    describe TeleportCmd do
      include PluginCmdTestHelper
      
      before do
        init_handler(TeleportCmd, "teleport somewhere")
        SpecHelpers.stub_translate_for_testing        
      end
      
      it_behaves_like "a plugin that doesn't allow switches"
      it_behaves_like "a plugin that requires login"
      it_behaves_like "a plugin that expects a single root" do
        let(:expected_root) { "teleport" }
      end
      
      describe :crack do
        it "should crack a destination only" do
          init_handler(TeleportCmd, "teleport somewhere")
          handler.crack!
          handler.name.should be_nil
          handler.destination.should eq "somewhere"
        end
        
        it "should crack a name plus destination" do
          init_handler(TeleportCmd, "teleport someone=somewhere")
          handler.crack!
          handler.name.should eq "someone"
          handler.destination.should eq "somewhere"
        end
      end
      
      describe :find_destination do
        it "should find the room when the destination is a char" do
          handler.stub(:destination) { "somewhere" }
          other_char = double
          room = double
          other_char.stub(:room) { room }
          ClassTargetFinder.should_receive(:find).with("somewhere", Character, client) { FindResult.new(other_char, nil) }
          ClassTargetFinder.should_not_receive(:find).with("somewhere", Room, client)
          handler.find_destination.should eq room
        end
        
        it "should find the room when the destination is a room" do
          handler.stub(:destination) { "somewhere" }
          room = double
          ClassTargetFinder.should_receive(:find).with("somewhere", Character, client) { FindResult.new(nil, "error") }
          ClassTargetFinder.should_receive(:find).with("somewhere", Room, client) { FindResult.new(room, nil) }
          handler.find_destination.should eq room
        end
        
        it "should return nil if nothing found" do
          handler.stub(:destination) { "somewhere" }
          ClassTargetFinder.should_receive(:find).with("somewhere", Character, client) { FindResult.new(nil, "error") }
          ClassTargetFinder.should_receive(:find).with("somewhere", Room, client) { FindResult.new(nil, "error") }
          handler.find_destination.should eq nil
        end
      end
      
      describe :find_targets do
        it "should return the client if there's no name" do
          handler.stub(:name) { nil }
          result = { :client => client, :char => char }
          handler.find_targets.should eq result
        end

        it "should return the matching char if there is one" do
          handler.stub(:name) { "someone" }
          other_char = double
          other_client = double
          client_monitor = double
          ClassTargetFinder.should_receive(:find).with("someone", Character, client) { FindResult.new(other_char, nil) }
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:find_client).with(other_char) { other_client }
          result = { :client => other_client, :char => other_char }
          handler.find_targets.should eq result
        end

        it "should return nil if nothing found" do
          handler.stub(:name) { "someone" }
          ClassTargetFinder.should_receive(:find).with("someone", Character, client) { FindResult.new(nil, "error") }
          result = { :client => nil, :char => nil }
          handler.find_targets.should eq result
        end
      end
      
      describe :handle do
        before do
          handler.stub(:destination) { "Somewhere" }
        end
        
        context "teleporting self" do
          before do
            @dest = double
            handler.stub(:find_destination) { @dest }
            handler.stub(:find_targets) { {:client => client, :char => char } }
          end
          
          it "should go to the room" do
            Rooms.should_receive(:move_to).with(client, char, @dest)
            handler.handle
          end
          
          it "should not emit to the client" do
            Rooms.stub(:move_to)
            client.should_not_receive(:emit_ooc)
            handler.handle
          end
        end  
        
        context "teleporting someone else" do
          before do
            @dest = double
            @other_char = double
            @other_client = double
            client.stub(:name) { "Bob" }
            handler.stub(:find_destination) { @dest }
            handler.stub(:find_targets) { {:client => @other_client, :char => @other_char } }
          end
          
          it "should go to the room" do
            Rooms.should_receive(:move_to).with(@other_client, @other_char, @dest)
            @other_client.stub(:emit_ooc)
            handler.handle
          end
          
          it "should tell the person they're being teleported" do
            Rooms.stub(:move_to)
            @other_client.should_receive(:emit_ooc).with('rooms.you_are_teleported')
            handler.handle
          end
        end        
        
        context "destination not found" do
          before do
            other_char = double
            other_client = double
            handler.stub(:find_destination) { nil }
            handler.stub(:find_targets) { {:client => other_client, :char => other_char } }
            client.stub(:emit_failure)
          end  
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("rooms.invalid_teleport_destination")          
            handler.handle
          end
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            handler.handle
          end
        end
        
        context "targets not found" do          
          before do
            handler.stub(:find_targets) { {:client => nil, :char => nil } }
            client.stub(:emit_failure)
          end  
          
          it "should emit failure" do
            client.should_receive(:emit_failure).with("db.object_not_found")          
            handler.handle
          end
          
          it "should not go anywhere" do
            Rooms.should_not_receive(:move_to)
            handler.handle
          end
        end
        
      end
    end
  end
end