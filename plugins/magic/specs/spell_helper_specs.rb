module AresMUSH
  module Magic
    describe Magic do


      describe :parse_spell_targets do

        before do
          @name_string = "Bob Jane"
          @bob = double
          @jane = double
          stub_translate_for_testing
        end

        
        it "returns npc_target if the target is an npc" do
          allow(Character).to receive(:named).with("Npc") {nil}
          expect(Magic.parse_spell_targets("npc", true)).to eq "npc_target"
        end

        it "returns an error if no character is found and the target isn't an npc" do
          allow(Character).to receive(:named).with("Bob") {@bob}
          allow(Character).to receive(:named).with("Jane") {nil}
          expect(Magic.parse_spell_targets(@name_string)).to eq "magic.invalid_name"
        end

        it "returns an array of character objects" do
          allow(Character).to receive(:named).with("Bob") {@bob}
          allow(Character).to receive(:named).with("Jane") {@jane}
          expect(Magic.parse_spell_targets(@name_string)).to eq [@bob, @jane]
        end

      end

      describe :spell_target_errors do
        before do
          @bob = double
          @jane = double
          @fran = double
          allow(Global).to receive(:read_config).with("spells", "Spell", "target_num") {4}
          allow(Global).to receive(:read_config).with("spells", "Spell", "heal_points")
          allow(FS3Combat).to receive(:worst_treatable_wound)
          stub_translate_for_testing
        end

        subject do 
          Magic.spell_target_errors([@bob, @jane, @fran], "Spell")
        end

        it "returns an error if there are more targets than listed in spell config" do
          allow(Global).to receive(:read_config).with("spells", "Spell", "target_num") {2}
          expect(subject).to eq "magic.too_many_targets"
        end

        it "returns an error if there are more than 1 target and no target_num is listed in spell config" do
          allow(Global).to receive(:read_config).with("spells", "Spell", "target_num") {nil}
          expect(subject).to eq "magic.too_many_targets"
        end

        it "does not return an error if there are fewer targets than are set in the spell config" do          
          expect(subject).to eq false
        end
        
        context "when the spell is a heal" do
          before do
            allow(Global).to receive(:read_config).with("spells", "Spell", "heal_points") {4}
          end
          it "returns an error if a target has no healable wounds" do
            allow(@bob).to receive(:name)
            allow(@jane).to receive(:name)
            allow(@fran).to receive(:name)
            expect(subject).to eq "magic.no_healable_wounds"            
          end
  
          it "does not return an error if all targets have healable wounds" do
            @damage = double
            allow(FS3Combat).to receive(:worst_treatable_wound) {@damage}
            expect(subject).to eq false            
          end

        end
        it "does not return an error if the target is an npc" do
          expect(Magic.spell_target_errors("npc_target", "Spell")).to eq false
        end

      end

      describe :print_target_names do
        it "prints names from an array of targets" do
          @bob = double
          @jane = double
          allow(@bob).to receive(:name) {"Bob"}
          allow(@jane).to receive(:name) {"Jane"}
          @targets = [@bob, @jane]
          expect(Magic.print_target_names(@targets)).to eq "Bob, Jane"
        end
      end

      describe :roll_noncombat_spell do
        before do
          allow(Magic).to receive(:spell_skill) {{skill: "Magic", cast_mod: 1}}
          allow(Magic).to receive(:spell_level_mod) {-2}
          allow(Magic).to receive(:item_spell_mod) {1}
          @caster = double
          allow(@caster).to receive(:name)
        end
        
        subject do
          Magic.roll_noncombat_spell(@caster, "Spell", 2)
        end

        it "adds the mods correctly" do
          expect(@caster).to receive(:roll_ability).with("Magic", 2) {{successes: 3}}
          subject
        end

        it "returns a hash" do
          allow(@caster).to receive(:roll_ability).with("Magic", 2) {{successes: 3}}
          allow(Magic).to receive(:spell_success).with(3) {"Success!"}

          expect(subject[:succeeds]).to eq "Success!"
          expect(subject[:result]).to eq 3
        end

      end

      describe :heal_all_unhealed_damage do
        before do
          @char = double
          @wound1 = double          
          allow(@wound1).to receive(:current_severity) {"FLESH"}
          allow(@wound1).to receive(:healed) {false}
          allow(@wound1).to receive(:healing_points) {4}
          allow(@wound1).to receive(:update)
          @wound2 = double
          allow(@wound2).to receive(:current_severity) {"IMPAIR"}
          allow(@wound2).to receive(:healed) {false}
          allow(@wound2).to receive(:healing_points) {9}
          allow(@wound2).to receive(:update)
          @healedwound = double
          allow(@healedwound).to receive(:current_severity) {"HEAL"}
          allow(@healedwound).to receive(:healed) {true}
          allow(@healedwound).to receive(:healing_points) {0}
          allow(@char).to receive(:damage) {[@wound1, @wound2, @healedwound]}
          allow(@char).to receive(:name)

        end

        subject do
          Magic.heal_all_unhealed_damage(@char)
        end

        context "when a wound is not fully healed" do
          it "sets the severity to HEAL" do
            expect(@wound1).to receive(:update).with(current_severity: "HEAL")
            expect(@wound2).to receive(:update).with(current_severity: "HEAL")
            subject
          end

          it "sets healed to true" do
            expect(@wound1).to receive(:update).with(healed: true)
            expect(@wound2).to receive(:update).with(healed: true)       
            subject
          end

          it "sets healing_points to 0" do
            expect(@wound1).to receive(:update).with(healing_points: 0)
            expect(@wound2).to receive(:update).with(healing_points: 0)  
            subject
          end

        end

        context "when a wound is fully healed" do
          it "ignores the wound" do

          end
        end

      end

    end
  end
end