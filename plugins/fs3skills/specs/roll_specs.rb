module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_luck") { 3 }
        allow(Global).to receive(:read_config).with("fs3skills", "roll_channel") { "FS3 Chan" }
        allow(Achievements).to receive(:award_achievement) {}
        # Note:  By seeding the random number generator, we can avoid the randomness.
        #   If you use Kernel.srand(22), the first 10 die rolls in tests will always be:  
        #      [6, 5, 5, 1, 5, 7, 7, 4, 5, 1]
        Kernel.srand 22

        stub_translate_for_testing
      end
      
      describe :emit_results do
        before do
          @main_client = double
          @main_char = double
          setup_mock_client(@main_client, @main_char)
                  
          @room = double
          allow(@main_char).to receive(:room) { @room }
          allow(@main_client).to receive(:emit)
          allow(@room).to receive(:emit)
        end
  
        context "private roll" do
          it "should emit to the client" do
            expect(@main_client).to receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
    
          it "should not emit to the room" do
            expect(@room).to_not receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
          
          it "should emit to the channel" do
            expect(Channels).to_not receive(:send_to_channel).with("FS3 Chan", "test")
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
        end
  
        context "public roll" do
          before do
            allow(Channels).to receive(:send_to_channel)
            allow(@room).to receive(:scene) { nil }
          end
          
          it "should emit to the room" do
            expect(@room).to receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
    
          it "should emit to the channel" do
            expect(Channels).to receive(:send_to_channel).with("FS3 Chan", "test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
          
          it "should emit to the scene" do
            scene = double
            allow(@room).to receive(:scene) { scene }
            expect(Scenes).to receive(:add_to_scene).with(scene, "test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
        end
      end
      
    
      describe :roll_ability do
        before do
          @client = double
          @char = double
          allow(@char).to receive(:name) { "Nemo" }
        end
        
        it "should roll ability" do
          roll_params = RollParams.new("Firearms")
          expect(FS3Skills).to receive(:dice_to_roll_for_ability).with(@char, roll_params) { 5 }
          expect(FS3Skills.roll_ability(@char, roll_params)).to eq [6, 5, 5, 1, 5]
        end
      end
    
      describe :roll_dice do
        it "should roll the specified number of dice" do
          expect(FS3Skills.roll_dice(4)).to eq [ 6, 5, 5, 1 ]
        end
        
        it "should always roll 1 die even if asked for 0 or less" do
          expect(FS3Skills.roll_dice(0)).to eq [6]
        end
        
        it "should not allow giant die rolls" do
          expect(FS3Skills.roll_dice(99)).to eq [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
        end
      end
    
      describe :get_success_level do
        it "should return number of successes if there are any" do
          expect(FS3Skills.get_success_level([7, 1, 3, 8])).to eq 2
        end
        
        it "should return a botch if there are more than two ones and no successes" do
          expect(FS3Skills.get_success_level([4, 1, 1, 1])).to eq -1
        end
        
        it "should return a failure if there are no successes but less than two ones." do
          expect(FS3Skills.get_success_level([4, 1, 3, 4])).to eq 0
        end
      end
      
    end
  end
end
