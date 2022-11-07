module AresMUSH
  module Magic
    class SpellsConfigValidator
      attr_accessor :validator

      def initialize
        @validator = Manage::ConfigValidator.new("spells")
      end

      def validate

        begin
          check_shields
          check_stuns
          check_attacks
          check_weapons
          check_weapon_specials
          check_armor
          check_armor_specials
          check_name
          check_mods

        rescue Exception => ex
          @validator.add_error "Unknown Spells config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end

        @validator.errors
      end

      def check_name
        spells = Global.read_config('spells')
        spells.each do |name, data|
          if name.titlecase != data['name'].titlecase
            @validator.add_error "#{name}'s 'name' does not match its entry name."
          end
        end
      end

      def check_shields
        spells = Global.read_config('spells').select { |name, data| data['is_shield'] == true }
        spells.each do |name, data|
          if !data['rounds']
            @validator.add_error "#{name} is a shield but has no rounds set."
          elsif !data['shields_against']
            @validator.add_error "#{name} is a shield but has no shields_against set."
          end
        end
      end

      def check_stuns
        spells = Global.read_config('spells').select { |name, data| data['is_stun'] == true }
        spells.each do |name, data|
          if !data['weapon']
            @validator.add_error "#{name} is a stun but has no weapon set."
          elsif !data['target_num']
            @validator.add_error "#{name} is a stun but has no target_num set."
          end
        end
      end

      def check_attacks
        spells = Global.read_config('spells').select { |name, data| data['fs3_attack'] == true }
        spells.each do |name, data|
          if !data['weapon']
            @validator.add_error "#{name} is an attack but has no weapon set."
          elsif !data['target_num']
            @validator.add_error "#{name} is an attack but has no target_num set."
          end
        end
      end

      def check_weapons
        spells = Global.read_config('spells').select { |name, data| data['weapon']}
        spells.each do |name, data|
          weapon_skill = FS3Combat.weapon_stat(data['weapon'], 'skill')
          ignore_skills = ["Melee", "Brawl"]
          if !FS3Combat.weapons.keys.include?(data['weapon'])
            @validator.add_error "#{name} uses a weapon of #{data['weapon']}, but that weapon does not exist."
          elsif data['weapon'] != "Spell" && !ignore_skills.include?(weapon_skill) && data['school'] != weapon_skill
            @validator.add_error "#{name} uses a weapon of #{data['weapon']}, but #{data['weapon']}'s skill does not match the spell's school."
          end
        end
      end

      def check_weapon_specials
        spells = Global.read_config('spells').select { |name, data| data['weapon_special']}
        spells.each do |name, data|
          if !FS3Combat.weapon_specials.keys.include?(data['weapon_specials'])
            @validator.add_error "#{name} uses a weapon special of #{data['weapon_specials']}, but that special does not exist."
          elsif !data['rounds']
            @validator.add_error "#{name} is a weapon special but has no rounds set."
          end
        end
      end

      def check_armor
        spells = Global.read_config('spells').select { |name, data| data['armor']}
        spells.each do |name, data|
          if !FS3Combat.armors.keys.include?(data['armor'])
            @validator.add_error "#{name} uses a armor of #{data['armor']}, but that armor does not exist."
          end
        end
      end

      def check_armor_specials
        spells = Global.read_config('spells').select { |name, data| data['armor_specials']}
        spells.each do |name, data|
          if !FS3Combat.armor_specials.keys.include?(data['armor_specials'])
            @validator.add_error "#{name} uses armor special of #{data['armor_specials']}, but that special does not exist."
          elsif !data['rounds']
            @validator.add_error "#{name} is an armor special but has no rounds set."
          end
        end
      end

      def check_mods
        spells = Global.read_config('spells').select { |name, data| data['attack_mod'] || data['defense_mod'] || data['init_mod'] || data['spell_mod'] || data['lethal_mod'] }
        spells.each do |name, data|
          if !data['rounds']
            @validator.add_error "#{name} is a mod spell but has no rounds set."
          end
        end
      end

    end
  end
end