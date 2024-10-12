require "plugin_test_loader"

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
            expect(Scenes).to receive(:custom_format).with("%xb<OOC>%xn A pose", @enactor_room, @char1, @enactor, false, true, nil)
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
            expect(Scenes).to receive(:custom_format).with("%R%xh%xc%% #{'-'.repeat(75)}%xn%R%RA pose%R%R%xh%xc%% #{'-'.repeat(75)}%xn%R", @enactor_room, @char1, @enactor, true, false, nil)
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
            expect(Scenes).to receive(:custom_format).with("A pose", @enactor_room, @char1, @enactor, false, false, nil)
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
            expect(Scenes).to receive(:custom_format).with("A pose", @enactor_room, @char1, @enactor, false, false, "A place")
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
            expect(Scenes).to receive(:custom_format).with("A pose", @scene_room, @char1, @enactor, false, false, nil)
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
      
      describe :handle_scene_participation_achievement do
        before do 
          @char = double
          @scene = double
          allow(@scene).to receive(:id) { 123 }
          allow(@scene).to receive(:scene_type) { "event" }
        end
        
        it "should not award anything if char already participated in scene." do
          expect(Scenes).to receive(:participated_in_scene?).with(@char, @scene) { true }
          expect(Achievements).to_not receive(:award_achievement).with(@char, "scene_participant", 1)
          Scenes.handle_scene_participation_achievement(@char, @scene)
        end
        
        it "should use the level not the count for awards." do
          expect(Scenes).to receive(:participated_in_scene?).with(@char, @scene) { false }
          expect(@char).to receive(:scenes_participated_in) { [ "1", "2" ]}
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant_event")
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant", 1)
          expect(@char).to receive(:update).with(:scenes_participated_in => [ "1", "2", "123" ])
          Scenes.handle_scene_participation_achievement(@char, @scene)
        end
        
        it "should award new level once they get enough scenes" do
          expect(Scenes).to receive(:participated_in_scene?).with(@char, @scene) { false }
          expect(@char).to receive(:scenes_participated_in) { [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]}
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant_event")
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant", 10)
          expect(@char).to receive(:update).with(:scenes_participated_in => [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "123" ])
          Scenes.handle_scene_participation_achievement(@char, @scene)
        end
        
        it "should award type achievement" do
          expect(Scenes).to receive(:participated_in_scene?).with(@char, @scene) { false }
          expect(@char).to receive(:scenes_participated_in) { [] }
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant_event")
          expect(Achievements).to receive(:award_achievement).with(@char, "scene_participant", 1)
          expect(@char).to receive(:update).with(:scenes_participated_in => [ "123" ])
          Scenes.handle_scene_participation_achievement(@char, @scene)
        end
      end
      
      describe :move_to_trash do 
        before do
          @enactor = double
          allow(@enactor).to receive(:name) { "Name" }
          
          @scene = double
          allow(@scene).to receive(:id) { "1" }
          allow(@scene).to receive(:participants) { [] }
          
          @pose1 = double
          @pose2 = double
          allow(@pose1).to receive(:is_real_pose?) { true }
          allow(@pose2).to receive(:is_real_pose?) { false }
          allow(@scene).to receive(:scene_poses) { [@pose1, @pose2] }

          trash_timeout_days = 15
          @now_time = Time.new(2023, 01, 02, 3, 0, 0)
          @trash_time = @now_time + (trash_timeout_days*86400)
          allow(Time).to receive(:now) { @now_time }

          allow(Global).to receive(:read_config).with("scenes", "scene_trash_timeout_days") { trash_timeout_days } 
          
          stub_translate_for_testing
        end
        
        it "should immediately delete a scene with no real poses" do
          allow(@pose1).to receive(:is_real_pose?) { false }

          expect(@scene).to receive(:delete)
          Scenes.move_to_trash(@scene, @enactor)
        end
        
        it "should not immediately delete a scene with at least one real pose" do
          allow(@pose1).to receive(:is_real_pose?) { true }
          allow(@scene).to receive(:update)
          expect(@scene).to_not receive(:delete)
          Scenes.move_to_trash(@scene, @enactor)
        end
        
        it "should mark the scene for trash" do
          expect(@scene).to receive(:update).with({ :in_trash => true })
          expect(@scene).to receive(:update).with({ :trash_date => @trash_time })
          expect(@scene).to_not receive(:delete)
          Scenes.move_to_trash(@scene, @enactor)
        end
        
        it "should not allow timeout less than 14 days" do
          allow(Global).to receive(:read_config).with("scenes", "scene_trash_timeout_days") { 5 } 
          @trash_time = @now_time + (14*86400)
          expect(@scene).to receive(:update).with({ :in_trash => true })
          expect(@scene).to receive(:update).with({ :trash_date => @trash_time })
          expect(@scene).to_not receive(:delete)
          Scenes.move_to_trash(@scene, @enactor)
        end
        
        it "should notify participants" do
          ppt1 = double("PPT1")
          ppt2 = double("PPT2")
          
          allow(@scene).to receive(:update)
          allow(@scene).to receive(:participants) { [ ppt1, ppt2 ] }
          
          expect(Login).to receive(:notify).with(ppt1, :scene, "scenes.scene_trash_warn", "1")
          expect(Login).to receive(:emit_ooc_if_logged_in).with(ppt1, "scenes.scene_trash_warn")
          expect(OOCTime).to receive(:local_short_timestr).with(ppt1, @trash_time) { "TIME" }

          expect(Login).to receive(:notify).with(ppt2, :scene, "scenes.scene_trash_warn", "1")
          expect(Login).to receive(:emit_ooc_if_logged_in).with(ppt2, "scenes.scene_trash_warn")
          expect(OOCTime).to receive(:local_short_timestr).with(ppt2, @trash_time) { "TIME" }
                    
          Scenes.move_to_trash(@scene, @enactor)
        end
          
        
      end
      
      describe :mark_unread do
        before do 
          @char1 = double("Char1")
          @char2 = double("Char2")
          @tracker1 = double("Tracker1")
          @tracker2 = double("Tracker2")
          @scene = double
          allow(@tracker1).to receive(:character) { @char1 }
          allow(@tracker2).to receive(:character) { @char2 }
          allow(ReadTracker).to receive(:all) { [ @tracker1, @tracker2 ]}
          
        end
        
        it "should mark unread only for someone who has already read it" do
          
          expect(@tracker1).to receive(:is_scene_unread?).with(@scene) { false }
          expect(@tracker2).to receive(:is_scene_unread?).with(@scene) { true }
          
          expect(@tracker1).to receive(:mark_scene_unread).with(@scene)
          expect(@tracker2).to_not receive(:mark_scene_unread).with(@scene)
          Scenes.mark_unread(@scene)          
        end
        
        it "should not mark unread if exception char specified" do
          
          expect(@tracker1).to receive(:is_scene_unread?).with(@scene) { false }
          expect(@tracker2).to receive(:is_scene_unread?).with(@scene) { true }
          
          expect(AresCentral).to receive(:is_alt?).with(@char1, @char1) { true }
          
          expect(@tracker1).to_not receive(:mark_scene_unread).with(@scene)
          expect(@tracker2).to_not receive(:mark_scene_unread).with(@scene)
          Scenes.mark_unread(@scene, @char1) 
        end
      end
      
      describe :add_log_version do 
        it "should add a log if there isn't one yet" do
          scene = double("scene")
          enactor = double("enactor")
          log = double("log")
          expect(scene).to receive(:scene_log) { nil }
          expect(SceneLog).to receive(:create) do |params|
            expect(params[:character]).to eq enactor
            expect(params[:scene]).to eq scene
            expect(params[:log]).to eq "LOG"
            log
          end
          expect(scene).to receive(:update) do |params|
            expect(params[:scene_log]).to eq log
          end
          Scenes.add_log_version(scene, "LOG", enactor)
          
        end
        
        it "should add a log if the text is different" do
          scene = double("scene")
          enactor = double("enactor")
          old_log = double("old_log")
          new_log = double("new_log")
          expect(scene).to receive(:scene_log) { old_log }
          allow(old_log).to receive(:log) { "OLD"}
          expect(SceneLog).to receive(:create) do |params|
            expect(params[:character]).to eq enactor
            expect(params[:scene]).to eq scene
            expect(params[:log]).to eq "NEW"
            new_log
          end
          expect(scene).to receive(:update) do |params|
            expect(params[:scene_log]).to eq new_log
          end
          Scenes.add_log_version(scene, "NEW", enactor)
        end
        
        it "should NOT add a log if the text is the same" do
          scene = double("scene")
          enactor = double("enactor")
          old_log = double("old_log")
          expect(scene).to receive(:scene_log) { old_log }
          allow(old_log).to receive(:log) { "SAME"}
          expect(SceneLog).to_not receive(:create)
          expect(scene).to_not receive(:update)
          Scenes.add_log_version(scene, "SAME", enactor)
          
        end
      end
      
    end
  end
end
