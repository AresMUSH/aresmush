require_relative "../../plugin_test_loader"

module AresMUSH
  module Scenes
    describe Scenes do
      include GlobalTestHelper
      
      describe :emit_pose do
        before do
          stub_global_objects      
          stub_translate_for_testing

          @enactor = double
          @enactor_room = double
          @char1 = double
          @char2 = double
          @client1 = double
          @client2 = double
          
          allow(@client1).to receive(:emit)
          allow(@client2).to receive(:emit)
          allow(@enactor).to receive(:room) { @enactor_room }
          allow(@enactor_room).to receive(:room_type) { "IC" }
          allow(@enactor_room).to receive(:characters) { [] }
          allow(dispatcher).to receive(:queue_event)
          allow(Scenes).to receive(:custom_format) { "Formatted pose" }
          allow(Login).to receive(:find_client).with(@char1) { @client1 }
          allow(Login).to receive(:find_client).with(@char2) { @client2 }
          allow(Scenes).to receive(:update_pose_order)
          allow(@enactor_room).to receive(:id) { 12 }
          allow(@enactor).to receive(:id) { 34 }
          
        end

        context "general" do

          it "should emit to all chars in room" do
            allow(@enactor_room).to receive(:characters) { [ @char1, @char2 ] }
            expect(@client1).to receive(:emit).with("Formatted pose")
            expect(@client2).to receive(:emit).with("Formatted pose")
            Scenes.emit_pose(@enactor, "A pose", false, false)
          end
          
        end
        
        context "ooc comment" do
          before do
            allow(Global).to receive(:read_config).with("scenes", "ooc_color") { "%xb" }
          end
          
          it "should format with color and <OOC> tag" do
            allow(@enactor_room).to receive(:characters) { [ @char1 ] }
            expect(Scenes).to receive(:custom_format).with("%xb<OOC>%xn A pose", @char1, @enactor, false, true, nil)
            Scenes.emit_pose(@enactor, "A pose", false, true)
          end

          it "should queue pose event" do
            expect(dispatcher).to receive(:queue_event) do |event|
              expect(event.enactor_id).to eq 34
              expect(event.pose).to eq "A pose"
              expect(event.room_id).to eq 12
              expect(event.is_emit).to eq false
              expect(event.is_ooc).to eq true
              expect(event.is_setpose).to eq false
            end
            Scenes.emit_pose(@enactor, "A pose", false, true)
          end
          
          it "should not trigger pose order" do
            expect(Scenes).not_to receive(:update_pose_order)
            Scenes.emit_pose(@enactor, "A pose", false, true)
          end
        end
        
        context "system pose" do
          before do
            allow(@enactor_room).to receive(:update)
          end
          
          it "should format a set pose with bracketed lines" do
            allow(@enactor_room).to receive(:characters) { [ @char1 ] }
            expect(Scenes).to receive(:custom_format).with("%R%xh%xc%% #{'-'.repeat(75)}%xn%R%RA pose%R%R%xh%xc%% #{'-'.repeat(75)}%xn%R", @char1, @enactor, true, false, nil)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, true)
          end
          
          it "should queue pose event" do
            expect(dispatcher).to receive(:queue_event) do |event|
              expect(event.enactor_id).to eq 34
              expect(event.pose).to eq "A pose"
              expect(event.room_id).to eq 12
              expect(event.is_emit).to eq true
              expect(event.is_ooc).to eq false
              expect(event.is_setpose).to eq true
            end
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, true)
          end
          
          it "should update pose order" do
            expect(Scenes).to receive(:update_pose_order).with(@enactor, @enactor_room)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, true)
          end
          
          it "should not update the room's set pose" do
            expect(@enactor_room).to_not receive(:update).with(:scene_set => "A pose")
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, true)
          end
          
        end
        
        context "regular pose" do
          
          it "should format a regular pose normally" do
            allow(@enactor_room).to receive(:characters) { [ @char1 ] }
            expect(Scenes).to receive(:custom_format).with("A pose", @char1, @enactor, false, false, nil)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false)
          end
          
          it "should queue pose event" do
            expect(dispatcher).to receive(:queue_event) do |event|
              expect(event.enactor_id).to eq 34
              expect(event.pose).to eq "A pose"
              expect(event.room_id).to eq 12
              expect(event.is_emit).to eq false
              expect(event.is_ooc).to eq false
              expect(event.is_setpose).to eq false
            end
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false)
          end
          
          it "should update pose order" do
            expect(Scenes).to receive(:update_pose_order).with(@enactor, @enactor_room)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false)
          end
          
          it "should not update pose order in an OOC room" do
            expect(@enactor_room).to receive(:room_type) { "OOC" }
            expect(Scenes).to_not receive(:update_pose_order)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false)
          end
          
          it "should use the place name in formatting" do
            allow(@enactor_room).to receive(:characters) { [ @char1 ] }
            expect(Scenes).to receive(:custom_format).with("A pose", @char1, @enactor, false, false, "A place")
            Scenes.emit_pose(@enactor, "A pose", false, false, "A place", false)
          end
        end
        
        
        context "scene room" do
          before do
            @scene_room = double
            allow(@scene_room).to receive(:room_type) { "IC" }
            allow(@scene_room).to receive(:characters) { [] }
            allow(@scene_room).to receive(:id) { 56 }
          end
          
          it "should format a regular pose normally" do
            allow(@scene_room).to receive(:characters) { [ @char1 ] }
            expect(Scenes).to receive(:custom_format).with("A pose", @char1, @enactor, false, false, nil)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false, @scene_room)
          end
          
          it "should queue pose event" do
            expect(dispatcher).to receive(:queue_event) do |event|
              expect(event.enactor_id).to eq 34
              expect(event.pose).to eq "A pose"
              expect(event.room_id).to eq 56
              expect(event.is_emit).to eq false
              expect(event.is_ooc).to eq false
              expect(event.is_setpose).to eq false
            end
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false, @scene_room)
          end
          
          it "should update pose order" do
            expect(Scenes).to receive(:update_pose_order).with(@enactor, @scene_room)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false, @scene_room)
          end
          
          it "should not update pose order in an OOC room" do
            expect(@scene_room).to receive(:room_type) { "OOC" }
            expect(Scenes).to_not receive(:update_pose_order)
            Scenes.emit_pose(@enactor, "A pose", false, false, nil, false, @scene_room)
          end          
        end
        
      end
    end
  end
end
