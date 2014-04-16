require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyConfirmCmd do
      include PluginCmdTestHelper
  
      before do
        init_handler(DestroyConfirmCmd, "destroy/confirm")
        SpecHelpers.stub_translate_for_testing
      end
      
      it_behaves_like "a plugin that requires login"
      
      describe :handle do
        before do
          @target = double
          @client_monitor = double
          Global.stub(:client_monitor) { @client_monitor }
          client.stub(:program) { { :destroy_target => @target, :something_else => "x" } }
          handler.crack!
        end
        
        context "failures" do
          it "should emit failure if the client is not doing a destroy" do
            client.stub(:program) { {} }
            client.should_receive(:emit_failure).with("manage.no_destroy_in_progress")
            handler.handle
          end

          it "should emit failure if trying to destroy a char who's online" do
            @target.stub(:class) { Character }
            @client_monitor.stub(:find_client).with(@target) { double }
            client.should_receive(:emit_failure).with("manage.cannot_destroy_online")
            handler.handle
          end
        end
        
        context "success" do
          before do
            @client_monitor.stub(:find_client) { nil }
            client.stub(:emit_success)
            @target.stub(:destroy)
            @target.stub(:name) { "name" }
          end
          
          it "should destroy the target" do
            @target.should_receive(:destroy)
            handler.handle
          end
          
          it "should emit success" do
            client.should_receive(:emit_success).with('manage.object_destroyed')
            handler.handle
          end
          
          it "should reset the client program" do
            handler.handle
            client.program[:something_else].should eq "x"
            client.program[:delete_cmd].should be_nil
          end 
        
          context "destroying a room" do
            before do
              # Stub out welcome room
              @welcome_room = double
              game = double
              Game.stub(:master) { game }
              game.stub(:welcome_room) { @welcome_room }

              # Pretend the target is a room
              @target.stub(:class) { Room }
              @char_in_room = double
              @target.stub(:characters) { [@char_in_room] }
            end
          
            it "should tell an online char they're being moved and move them" do
              # Match up a client to the character
              client_in_room = double
              @client_monitor.stub(:find_client).with(@char_in_room) { client_in_room }
              client_in_room.should_receive(:emit_ooc).with("manage.room_being_destroyed")
              Rooms.should_receive(:move_to).with(client_in_room, @char_in_room, @welcome_room)
              handler.handle
            end
          
            it "should move them to the welcome room" do
              Rooms.should_receive(:move_to).with(nil, @char_in_room, @welcome_room)
              handler.handle
            end
          end
        end
      end
    end
  end
end