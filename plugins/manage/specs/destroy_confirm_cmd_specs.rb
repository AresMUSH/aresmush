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
          allow(FS3Combat).to receive(:is_in_combat?) { false }
          
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
          
        
          it "should emit failure if trying to destroy a char in combat" do
            allow(@target).to receive(:name) { "Bob" }
            allow(@target).to receive(:class) { Character }
            allow(FS3Combat).to receive(:is_in_combat?).with("Bob") { true }
            expect(@client).to receive(:emit_failure).with("manage.cannot_destroy_in_combat")
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
        end
      end
    end
  end
end
