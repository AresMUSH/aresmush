module AresMUSH
  module FS3Combat
    describe FullautoAction do
      before do
        @action = FullautoAction.new
        @combatant = Combatant.new(:name => "Bob")
        @target1 = double
        @target2 = double
        @target3 = double
        @target4 = double
        @combat = double

        @action.stub(:combat) { @combat }
        @action.stub(:combatant) { @combatant }
        SpecHelpers.stub_translate_for_testing
      end
      
      describe :resolve do
        before do
          @combatant.stub(:update_ammo) { }
        end
          
        it "should attack eight times against a single target" do
          @action.stub(:targets) { [@target1] }
          @combatant.should_receive(:attack_target).with(@target1) { "result1" }
          @combatant.should_receive(:attack_target).with(@target1) { "result2" }
          @combatant.should_receive(:attack_target).with(@target1) { "result3" }
          @combatant.should_receive(:attack_target).with(@target1) { "result4" }
          @combatant.should_receive(:attack_target).with(@target1) { "result5" }
          @combatant.should_receive(:attack_target).with(@target1) { "result6" }
          @combatant.should_receive(:attack_target).with(@target1) { "result7" }
          @combatant.should_receive(:attack_target).with(@target1) { "result8" }
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_fullauto"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions[3].should eq "result3"
          resolutions[4].should eq "result4"
          resolutions[5].should eq "result5"
          resolutions[6].should eq "result6"
          resolutions[7].should eq "result7"
          resolutions[8].should eq "result8"
          resolutions.count.should eq 9
        end
        
        it "should attack four times each against two targets" do
          @action.stub(:targets) { [@target1, @target2] }
          @combatant.should_receive(:attack_target).with(@target1) { "result1" }
          @combatant.should_receive(:attack_target).with(@target1) { "result2" }
          @combatant.should_receive(:attack_target).with(@target1) { "result3" }
          @combatant.should_receive(:attack_target).with(@target1) { "result4" }
          @combatant.should_receive(:attack_target).with(@target2) { "result5" }
          @combatant.should_receive(:attack_target).with(@target2) { "result6" }
          @combatant.should_receive(:attack_target).with(@target2) { "result7" }
          @combatant.should_receive(:attack_target).with(@target2) { "result8" }
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_fullauto"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions[3].should eq "result3"
          resolutions[4].should eq "result4"
          resolutions[5].should eq "result5"
          resolutions[6].should eq "result6"
          resolutions[7].should eq "result7"
          resolutions[8].should eq "result8"
          resolutions.count.should eq 9
        end
        
        it "should attack two times each against three targets" do
          @action.stub(:targets) { [@target1, @target2, @target3] }
          @combatant.should_receive(:attack_target).with(@target1) { "result1" }
          @combatant.should_receive(:attack_target).with(@target1) { "result2" }
          @combatant.should_receive(:attack_target).with(@target2) { "result3" }
          @combatant.should_receive(:attack_target).with(@target2) { "result4" }
          @combatant.should_receive(:attack_target).with(@target3) { "result5" }
          @combatant.should_receive(:attack_target).with(@target3) { "result6" }
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_fullauto"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions[3].should eq "result3"
          resolutions[4].should eq "result4"
          resolutions[5].should eq "result5"
          resolutions[6].should eq "result6"
          resolutions.count.should eq 7
        end
        
        it "should attack one time each against five targets" do
          @action.stub(:targets) { [@target1, @target2, @target3, @target4, @target5] }
          @combatant.should_receive(:attack_target).with(@target1) { "result1" }
          @combatant.should_receive(:attack_target).with(@target2) { "result2" }
          @combatant.should_receive(:attack_target).with(@target3) { "result3" }
          @combatant.should_receive(:attack_target).with(@target4) { "result4" }
          @combatant.should_receive(:attack_target).with(@target5) { "result5" }
          resolutions = @action.resolve
          resolutions[0].should eq "fs3combat.fires_fullauto"
          resolutions[1].should eq "result1"
          resolutions[2].should eq "result2"
          resolutions[3].should eq "result3"
          resolutions[4].should eq "result4"
          resolutions[5].should eq "result5"
          resolutions.count.should eq 6
        end
        
        it "should update ammo" do
          @combatant.should_receive(:update_ammo).with(8)
          @action.resolve
        end

      end
    end
  end
end