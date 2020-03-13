module AresMUSH
  module FS3Skills
    describe FS3Skills do

      before do
        allow(Global).to receive(:read_config).with("fs3skills", "max_xp_hoard") { 3 }
        stub_translate_for_testing
      end
      
      describe :award_xp do
        before do
          @char = Character.new(fs3_xp: 1)
        end
        
        it "should add xp" do
          expect(@char).to receive(:update).with(fs3_xp: 2)
          @char.award_xp(1)
        end

        it "should not go over the cap" do
          expect(@char).to receive(:update).with(fs3_xp: 3)
          @char.award_xp(5)
        end
      end
      
      describe :check_can_learn do
        before do
          @char = double
          allow(Global).to receive(:read_config).with("fs3skills", "max_points_on_attrs") { 14 }
          allow(Global).to receive(:read_config).with("fs3skills", "max_points_on_action") { 10 }
          allow(Global).to receive(:read_config).with("fs3skills", "max_points_on_advantages") { 10 }
          allow(Global).to receive(:read_config).with("fs3skills", "attr_dots_beyond_chargen_max") { 1 }
          allow(Global).to receive(:read_config).with("fs3skills", "action_dots_beyond_chargen_max") { 2 }
          allow(Global).to receive(:read_config).with("fs3skills", "advantage_dots_beyond_chargen_max") { 2 }
          allow(Global).to receive(:read_config).with("fs3skills", "advantages_cost") { 2 }
          allow(FS3Skills).to receive(:get_ability_type).with("Firearms") { :action }
          allow(FS3Skills).to receive(:get_ability_type).with("Reflexes") { :attribute }
          allow(FS3Skills).to receive(:get_ability_type).with("Rank") { :advantage }
        end
        
        it "should return false if next rating not in cost chart" do
          expect(FS3Skills).to receive(:xp_needed).with("Firearms", 4) { nil }
          expect(FS3Skills.check_can_learn(@char, "Firearms", 4)).to eq "fs3skills.cant_raise_further_with_xp"
        end
        
        it "should return false if char is at max in action already" do
          expect(FS3Skills).to receive(:xp_needed).with("Firearms", 4) { 4 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_action).with(@char) { 12 }
          expect(FS3Skills.check_can_learn(@char, "Firearms", 4)).to eq "fs3skills.max_ability_points_reached"
        end
        
        it "should return ok if char would be at max after spending on action" do
          expect(FS3Skills).to receive(:xp_needed).with("Firearms", 4) { 4 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_action).with(@char) { 10 }
          expect(FS3Skills.check_can_learn(@char, "Firearms", 4)).to eq nil
        end
        
        it "should return false if char is at max in attrs already" do
          expect(FS3Skills).to receive(:xp_needed).with("Reflexes", 4) { 4 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_attrs).with(@char) { 16 }
          expect(FS3Skills.check_can_learn(@char, "Reflexes", 4)).to eq "fs3skills.max_ability_points_reached"
        end

        it "should return ok if char would be at max after spending on attrs" do
          expect(FS3Skills).to receive(:xp_needed).with("Reflexes", 4) { 4 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_attrs).with(@char) { 14 }
          expect(FS3Skills.check_can_learn(@char, "Reflexes", 4)).to eq nil
        end
        
        it "should return false if char is at max in adv already" do
          expect(FS3Skills).to receive(:xp_needed).with("Rank", 3) { 3 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_advantages).with(@char) { 14 }
          expect(FS3Skills.check_can_learn(@char, "Rank", 3)).to eq "fs3skills.max_ability_points_reached"
        end
        
        it "should return ok if char would be at max after spending on adv" do
          expect(FS3Skills).to receive(:xp_needed).with("Rank", 3) { 4 }
          allow(FS3Skills::AbilityPointCounter).to receive(:points_on_advantages).with(@char) { 12 }
          expect(FS3Skills.check_can_learn(@char, "Rank", 3)).to eq nil
        end
        
      end
      
      describe :xp do
        before do
          @char = Character.new(fs3_xp: 2)
        end
        
        it "should return xp" do
          expect(@char.xp).to eq 2
        end
      end
    end
  end
end
