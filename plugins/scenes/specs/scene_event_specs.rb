require "plugin_test_loader"

module AresMUSH
  module Scenes
    describe CronEventHandler do      
      describe :delete_unshared_scenes do
        before do
          @handler = CronEventHandler.new
          
          @now_time = Time.new(2023, 01, 02, 3, 0, 0)
          allow(Time).to receive(:now) { @now_time }
          
          @s1 = double("Scene1")
          @s2 = double("Scene2")
          @s3 = double("Scene3")
          @s4 = double("Scene4")
          
          # Scene 1 - unshared
          allow(@s1).to receive(:completed) { true }
          allow(@s1).to receive(:shared) { false }
          allow(@s1).to receive(:in_trash) { false }
          allow(@s1).to receive(:days_since_last_activity) { 1 }

          # Scene 2 - in trash
          allow(@s2).to receive(:completed) { true }
          allow(@s2).to receive(:shared) { false }
          allow(@s2).to receive(:in_trash) { true }
          allow(@s2).to receive(:trash_date) { @now_time + 200000 }

          # Scene 3 - shared
          allow(@s3).to receive(:completed) { true }
          allow(@s3).to receive(:shared) { true }
          allow(@s3).to receive(:in_trash) { false }
                    
          # Scene 4 - active
          allow(@s4).to receive(:completed) { false }
          allow(@s4).to receive(:shared) { false }
          allow(@s4).to receive(:in_trash) { false }

          allow(Scene).to receive(:all) { [ @s1, @s2, @s3, @s4 ]}
          allow(Global).to receive(:read_config).with("scenes", "delete_unshared_scenes") { true } 
          allow(Global).to receive(:read_config).with("scenes", "unshared_scene_warning_days") { 5 } 
          
          @system_char = double
          game_master = double
          allow(game_master).to receive(:system_character) { @system_char }
          allow(Game).to receive(:master) { game_master }
          
        end
        
        it "should delete a scene past its trash date if not completed or shared" do
          allow(@s2).to receive(:trash_date) { @now_time - 200000 }
          allow(@s2).to receive(:id) { 1 }

          expect(@s2).to receive(:delete)

          @handler.delete_unshared_scenes
        end
        
        
        it "should not touch a shared scene past its trash date" do
          allow(@s2).to receive(:trash_date) { @now_time - 200000 }
          allow(@s2).to receive(:shared) { true }

          expect(@s2).to_not receive(:delete)

          @handler.delete_unshared_scenes
        end
        
        it "should not touch an active scene past its trash date" do
          allow(@s2).to receive(:trash_date) { @now_time - 200000 }
          allow(@s2).to receive(:completed) { false }

          expect(@s2).to_not receive(:delete)

          @handler.delete_unshared_scenes
        end
        
        it "should not delete shared or active scenes " do
          expect(@s3).to_not receive(:delete)
          expect(@s4).to_not receive(:delete)

          @handler.delete_unshared_scenes
        end
        
        it "should mark scene as trashed if no recent activity" do
          allow(@s1).to receive(:days_since_last_activity) { 10 }

          expect(Scenes).to receive(:move_to_trash).with(@s1, @system_char)

          @handler.delete_unshared_scenes
        end
        
        it "should not mark scene as trashed if recent activity" do
          allow(@s1).to receive(:days_since_last_activity) { 1 }

          expect(Scenes).to_not receive(:move_to_trash).with(@s1, @system_char)

          @handler.delete_unshared_scenes
        end
        
        it "should not mark scene as trashed if shared or active" do
          allow(@s3).to receive(:days_since_last_activity) { 1 }
          allow(@s4).to receive(:days_since_last_activity) { 1 }

          expect(Scenes).to_not receive(:move_to_trash).with(@s3, @system_char)
          expect(Scenes).to_not receive(:move_to_trash).with(@s4, @system_char)

          @handler.delete_unshared_scenes
        end
        
        it "should not mark scene as trashed if feature disabled" do
          allow(@s1).to receive(:days_since_last_activity) { 10 }
          allow(Global).to receive(:read_config).with("scenes", "delete_unshared_scenes") { false } 

          expect(Scenes).to_not receive(:move_to_trash).with(@s1, @system_char)

          @handler.delete_unshared_scenes
        end
        
      end
    end
  end
end
