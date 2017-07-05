module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        Global.stub(:read_config).with("fs3skills", "max_luck") { 3 }
        Global.stub(:read_config).with("fs3skills", "roll_channel") { "FS3 Chan" }

        # Note:  By seeding the random number generator, we can avoid the randomness.
        #   If you use Kernel.srand(22), the first 10 die rolls in tests will always be:  
        #      [6, 5, 5, 1, 5, 7, 7, 4, 5, 1]
        Kernel.srand 22

        SpecHelpers.stub_translate_for_testing
      end
      
      describe :emit_results do
        before do
          @main_client = double
          @main_char = double
          SpecHelpers.setup_mock_client(@main_client, @main_char)
    
          @admin_client = double
          @admin_char = double
          SpecHelpers.setup_mock_client(@admin_client, @admin_char)
    
          @nonadmin_client = double
          @nonadmin_char = double 
          SpecHelpers.setup_mock_client(@nonadmin_client, @nonadmin_char)
    
          FS3Skills.stub(:receives_roll_results?).with(@main_char) { true }
          FS3Skills.stub(:receives_roll_results?).with(@admin_char) { true }
          FS3Skills.stub(:receives_roll_results?).with(@nonadmin_char) { false }
    
          @room = double
          @main_char.stub(:room) { @room }
          @admin_char.stub(:room) { @room }
          @nonadmin_char.stub(:room) { @room }
              
          client_monitor = double
          Global.stub(:client_monitor) { client_monitor }
          client_monitor.stub(:logged_in) { 
            {
              @admin_client => @admin_char,
              @main_client => @main_char,
              @nonadmin_client => @nonadmin_char
            } 
          }
        end
  
        context "private roll" do
          it "should emit to the client" do
            @main_client.should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
    
          it "should not emit to the room or anyone else" do
            @room.should_not_receive(:emit).with("test")
            @admin_client.should_not_receive(:emit).with("test")
            @nonadmin_client.should_not_receive(:emit).with("test")
            @main_client.stub(:emit)
            @admin_client.stub(:emit)
            FS3Skills.emit_results("test", @main_client, @room, true)
          end
        end
  
        context "public roll" do
          before do
            Channels.stub(:send_to_channel)
            @room.stub(:scene) { nil }
            @room.stub(:emit)
          end
          
          it "should emit to the room" do
            @admin_char.stub(:room) { nil }
            @admin_client.should_not_receive(:emit).with("test")
            @nonadmin_client.should_not_receive(:emit).with("test")
            @room.should_receive(:emit).with("test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
    
          it "should emit to the channel" do
            Channels.should_receive(:send_to_channel).with("FS3 Chan", "test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
          
          it "should emit to the scene" do
            scene = double
            @room.stub(:scene) { scene }
            Scenes::Api.should_receive(:add_pose).with(scene, "test")
            FS3Skills.emit_results("test", @main_client, @room, false)
          end
        end
      end
      
    
      describe :roll_ability do
        before do
          @client = double
          @char = double
          @char.stub(:name) { "Nemo" }
        end
        
        it "should roll ability" do
          roll_params = RollParams.new("Firearms")
          FS3Skills.should_receive(:dice_to_roll_for_ability).with(@char, roll_params) { 5 }
          FS3Skills.roll_ability(@client, @char, roll_params).should eq [6, 5, 5, 1, 5]
        end
      end
    
      describe :roll_dice do
        it "should roll the specified number of dice" do
          FS3Skills.roll_dice(4).should eq [ 6, 5, 5, 1 ]
        end
        
        it "should always roll 1 die even if asked for 0 or less" do
          FS3Skills.roll_dice(0).should eq [6]
        end
        
        it "should not allow giant die rolls" do
          FS3Skills.roll_dice(99).should eq [8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]
        end
      end
    
      describe :get_success_level do
        it "should return number of successes if there are any" do
          FS3Skills.get_success_level([7, 1, 3, 8]).should eq 2
        end
        
        it "should return a botch if there are more than two ones and no successes" do
          FS3Skills.get_success_level([4, 1, 1, 1]).should eq -1
        end
        
        it "should return a failure if there are no successes but less than two ones." do
          FS3Skills.get_success_level([4, 1, 3, 4]).should eq 0
        end
      end
      
    end
  end
end
