require_relative "../../plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyConfirmCmd do  
      before do
        @client = double
        @enactor = double
        @handler = DestroyConfirmCmd.new(@client, nil, @enactor)
        SpecHelpers.stub_translate_for_testing
        @game = double
        Game.stub(:master) { @game }
      end
            
      describe :handle do
        before do
          @target = Character.new
          @target.stub(:id) { "X" }
          @target.stub(:is_online?) { false }
          ClassTargetFinder.stub(:find).with("X", @target.class, @enactor) { FindResult.new(@target, nil) }
          @client.stub(:program) { { :destroy_target => @target.id, 
               :destroy_class => @target.class,
               :something_else => "x" } }
          Manage.stub(:can_manage_object?) { true }
          @handler.parse_args
        end
        
        context "failures" do
          it "should emit failure if the client is not doing a destroy" do
            @client.stub(:program) { {} }
            @client.should_receive(:emit_failure).with("manage.no_destroy_in_progress")
            @handler.handle
          end

          it "should emit failure if trying to destroy a char who's online" do
            @target.stub(:is_online?) { true }
            @client.should_receive(:emit_failure).with("manage.cannot_destroy_online")
            @handler.handle
          end
          
          it "should emit failure if the char doesn't have permission" do
            Manage.should_receive(:can_manage_object?) { false }
            @client.should_receive(:emit_failure).with("dispatcher.not_allowed")
            @handler.handle
          end
        end
        
        context "success" do
          before do
            @client.stub(:emit_success)
            @target.stub(:delete) {}
            @target.stub(:name) { "name" }
          end
          
          it "should destroy the target" do
            @target.should_receive(:delete)
            @handler.handle
          end
          
          it "should emit success" do
            @client.should_receive(:emit_success).with('manage.object_destroyed')
            @handler.handle
          end
          
          it "should reset the client program" do
            @handler.handle
            @client.program[:something_else].should eq "x"
            @client.program[:delete_cmd].should be_nil
          end 
        
          context "destroying a room" do
            before do

              # Stub out welcome room
              @welcome_room = double
              @game.stub(:welcome_room) { @welcome_room }

              # Pretend the target is a room
              @target.stub(:class) { Room }
              ClassTargetFinder.stub(:find).with("X", @target.class, @enactor) { FindResult.new(@target, nil) }

              @char_in_room = double
              @target.stub(:characters) { [@char_in_room] }
            end
          
            it "should tell an online char they're being moved and move them" do
              # Match up a client to the character
              client_in_room = double
              @char_in_room.stub(:client) { client_in_room }
              client_in_room.should_receive(:emit_ooc).with("manage.room_being_destroyed")
              Rooms.should_receive(:send_to_welcome_room).with(client_in_room, @char_in_room)
              @handler.handle
            end
          
            it "should move them to the welcome room" do
              @char_in_room.stub(:client) { nil }
              Rooms.should_receive(:send_to_welcome_room).with(nil, @char_in_room)
              @handler.handle
            end
          end
        end
      end
    end
  end
end