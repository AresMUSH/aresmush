module AresMUSH
  module FS3Combat
    describe FS3Combat do
      include MockClient
      
      before do
        Global.stub(:read_config).with("fs3combat", "toughness_aptitude") { "Body" }
        Global.stub(:read_config).with("fs3combat", "default_treat_skill") { "First Aid" }
        SpecHelpers.stub_translate_for_testing        
      end
        
      describe :print_damage do
        it "should print the right damage" do
          FS3Combat.print_damage(0).should eq "----"
          FS3Combat.print_damage(0.25).should eq "X---"
          FS3Combat.print_damage(1.0).should eq "X---"
          FS3Combat.print_damage(1.25).should eq "XX--"
          FS3Combat.print_damage(2.25).should eq "XXX-"
          FS3Combat.print_damage(3.25).should eq "XXXX"
          FS3Combat.print_damage(5).should eq "XXXX"
        end
      end
      
      describe :heal_wounds do
        before do
          @char = double
          @char.stub(:name) { "Bob" }
          @damage1 = double
          @damage2 = double
          @wounds =  [@damage1, @damage2]
        end
        
        it "should apply healing points based on half successes" do
          FS3Skills::Interface.stub(:one_shot_roll) { { :successes => 0 }}
          @damage1.should_receive(:heal).with(2, true)
          @damage2.should_receive(:heal).with(2, true)
          FS3Combat.heal_wounds(@char, @wounds, true, 3)
        end
        
        it "should add a body roll to the healing points" do
          FS3Skills::Interface.should_receive(:one_shot_roll) do |client, char, roll_params|
            client.should be_nil
            char.should eq @char
            roll_params.ability.should eq "Body"
            roll_params.related_apt.should eq "Body"
            { :successes => 2 }
          end
          @damage1.should_receive(:heal).with(3, true)
          @damage2.should_receive(:heal).with(3, true)        
          FS3Combat.heal_wounds(@char, @wounds, true, 3)
        end
        
        it "should not mark wounds as treated if not treated" do
          FS3Skills::Interface.stub(:one_shot_roll) { { :successes => 1 }}
          @damage1.should_receive(:heal).with(1, false)
          @damage2.should_receive(:heal).with(1, false)        
          FS3Combat.heal_wounds(@char, @wounds)
        end

        it "should  mark wounds as treated even if no healing points" do
          FS3Skills::Interface.stub(:one_shot_roll) { { :successes => 1 }}
          @damage1.should_receive(:heal).with(1, true)
          @damage2.should_receive(:heal).with(1, true)        
          FS3Combat.heal_wounds(@char, @wounds, true, 0)
        end
      end
      
      describe :total_damage_mod do
        it "should count all wound levels" do
          damage1 = double
          damage2 = double
          damage1.stub(:wound_mod) { 1 }
          damage2.stub(:wound_mod) { 2 }
          wounds = [ damage1, damage2 ]
          FS3Combat.total_damage_mod(wounds).should eq 3
        end

        it "should count empty damage" do
          wounds = []
          FS3Combat.total_damage_mod(wounds).should eq 0
        end        
      end
      
      describe :do_treat do
        before do 
          @char = double
          @char.stub(:name) { "Bob" }
          @damage1 = double
          @damage2 = double
          @target = double
          @wounds = [@damage1, @damage2]
          @target.stub(:treatable_wounds) { @wounds }
          @target.stub(:name) { "Patient" }
          
        end
        
        it "should roll the char's treat ability if set" do
          @char.stub(:treat_skill) { "ER Doc" }
          FS3Skills::Interface.should_receive(:one_shot_roll) do |client, char, params|
            char.should eq @char
            params.ability.should eq "ER Doc"
            { :successes => 2}
          end
          FS3Combat.should_receive(:heal_wounds).with(@target, @wounds, true, 2)
          FS3Combat.do_treat(@char, @target).should eq "fs3combat.treat_success"
        end
        
        it "should roll the default treat ability if the char doesn't have one" do
          @char.stub(:treat_skill) { nil }
          FS3Skills::Interface.should_receive(:one_shot_roll) do |client, char, params|
            char.should eq @char
            params.ability.should eq "First Aid"
            { :successes => 2 }
          end
          FS3Combat.should_receive(:heal_wounds).with(@target, @wounds, true, 2)
          FS3Combat.do_treat(@char, @target).should eq "fs3combat.treat_success"
        end
        
        it "should not do anything if no treatable wounds" do
          @target.stub(:treatable_wounds) { [] }
          FS3Combat.should_not_receive(:heal_wounds)
          FS3Combat.do_treat(@char, @target).should eq "fs3combat.no_treatable_wounds"
        end
      end
    end
  end
end