require "plugin_test_loader"

module AresMUSH
  module Manage
    describe DestroyConfirmCmd do  
      before do
        @client = double
        @enactor = double
        @handler = DestroyConfirmCmd.new(@client, nil, @enactor)
        stub_translate_for_testing
        @game = double
        allow(Game).to receive(:master) { @game }
      end
            
      describe :handle do
        before do
          @target = Character.new
          allow(@target).to receive(:id) { "X" }
          allow(Login).to receive(:is_online?).with(@target) { false }
          allow(ClassTargetFinder).to receive(:find).with("X", @target.class, @enactor) { FindResult.new(@target, nil) }
          allow(@client).to receive(:program) { { :destroy_target => @target.id, 
               :destroy_class => @target.class,
               :something_else => "x" } }
          allow(Manage).to receive(:can_manage_object?) { true }
          @handler.parse_args
        end
        
        context "failures" do
          it "should emit failure if the client is not doing a destroy" do
            allow(@client).to receive(:program) { {} }
            expect(@client).to receive(:emit_failure).with("manage.no_destroy_in_progress")
            @handler.handle
          end

          it "should emit failure if trying to destroy a char who's online" do
            allow(Login).to receive(:is_online?).with(@target) { true }
            expect(@client).to receive(:emit_failure).with("manage.cannot_destroy_online")
            @handler.handle
          end
          
          it "should emit failure if the char doesn't have permission" do
            expect(Manage).to receive(:can_manage_object?) { false }
            expect(@client).to receive(:emit_failure).with("dispatcher.not_allowed")
            @handler.handle
          end
        end
        
        context "success" do
          before do
            allow(@client).to receive(:emit_success)
            allow(@target).to receive(:delete) {}
            allow(@target).to receive(:name) { "name" }
          end
          
          it "should destroy the target" do
            expect(@target).to receive(:delete)
            @handler.handle
          end
          
          it "should emit success" do
            expect(@client).to receive(:emit_success).with('manage.object_destroyed')
            @handler.handle
          end
          
          it "should reset the client program" do
            @handler.handle
            expect(@client.program[:something_else]).to eq "x"
            expect(@client.program[:delete_cmd]).to be_nil
          end 
        
          context "destroying a room" do
            before do

              # Stub out welcome room
              @welcome_room = double
              allow(@game).to receive(:welcome_room) { @welcome_room }

              # Pretend the target is a room
              allow(@target).to receive(:class) { Room }
              allow(ClassTargetFinder).to receive(:find).with("X", @target.class, @enactor) { FindResult.new(@target, nil) }

              @char_in_room = double
              allow(@target).to receive(:characters) { [@char_in_room] }
            end
          
            it "should tell an online char they're being moved and move them" do
              # Match up a client to the character
              client_in_room = double
              allow(Login).to receive(:find_client).with(@char_in_room) { client_in_room }
              expect(client_in_room).to receive(:emit_ooc).with("manage.room_being_destroyed")
              expect(Rooms).to receive(:send_to_welcome_room).with(client_in_room, @char_in_room)
              @handler.handle
            end
          
            it "should move them to the welcome room" do
              allow(Login).to receive(:find_client).with(@char_in_room) { nil }
              expect(Rooms).to receive(:send_to_welcome_room).with(nil, @char_in_room)
              @handler.handle
            end
          end
        end
      end
    end
  end
end
