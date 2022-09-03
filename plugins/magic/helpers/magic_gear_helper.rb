require 'byebug'
module AresMUSH
  module Magic

    def self.mundane_armors
      Global.read_config("fs3combat", "armor").select{ |k, a| !a['is_magic'] }
    end

    def self.mundane_weapons
      Global.read_config("fs3combat", "weapons").select { |k, w| !w['is_magic'] }
    end

    def self.mundane_weapon_specials
      FS3Combat.weapon_specials.select { |k, w| !w['is_magic'] }
    end

    #Can read armor or weapon
    def self.is_magic_weapon(gear)
      FS3Combat.weapon_stat(gear, "is_magic")
    end

    def self.is_magic_armor(gear)
      FS3Combat.armor_stat(gear, "is_magic")
    end

    def self.warn_if_magic_gear(enactor, gear)
      if Magic.is_magic_armor(gear) || Magic.is_magic_weapon(gear)
        FS3Combat.emit_to_combat(enactor.combat, t('magic.cast_to_use', :name => gear))
      end
    end

    def self.set_magic_weapon_effects(combatant, spell)
      #Sets weapon specials that are gained via a spell
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "weapon_specials")
      weapon = combatant.weapon.before("+")
      weapon_specials = combatant.magic_weapon_effects

      if combatant.magic_weapon_effects.has_key?(weapon)
        old_weapon_specials = weapon_specials[weapon]
        weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
        #Rounds don't actually count down on newturn.
      else
        weapon_specials[weapon] = {special => rounds}
      end
      combatant.update(magic_weapon_effects: weapon_specials)
    end

    def self.magic_weapon_specials(combatant, weapon)
      #Returns all specials gained by magical means
      specials = []

      item_specials = Magic.magic_item_weapon_specials(combatant)
      if item_specials
        specials = specials.concat item_specials
      end

      magic_weapon_specials = combatant.magic_weapon_specials.select{ |s| s.weapon == weapon}.map {|s| s.name}

      if !magic_weapon_specials.empty?
        specials = specials.concat magic_weapon_specials
      end

      return specials
    end

    def self.set_magic_weapon(combatant, weapon)
      #Used for setting a weapon via magic
      #Does not reset action, unlike vanilla FS3 set_weapon
      #Does not allow additional specials
      specials = Magic.magic_weapon_specials(combatant, weapon)

      max_ammo = weapon ? FS3Combat.weapon_stat(weapon, "ammo") : 0
      weapon = weapon ? weapon.titlecase : "Unarmed"
      prior_ammo = combatant.prior_ammo || {}

      current_ammo = max_ammo
      if (weapon && prior_ammo[weapon] != nil)
        current_ammo = prior_ammo[weapon]
      end

      if (combatant.weapon_name)
        prior_ammo[combatant.weapon_name] = combatant.ammo
        combatant.update(prior_ammo: prior_ammo)
      end

      combatant.update(weapon_name: weapon)
      combatant.update(weapon_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
      combatant.update(ammo: current_ammo)
      combatant.update(max_ammo: max_ammo)

      message = t('fs3combat.weapon_changed', :name => combatant.name,
        :weapon => combatant.weapon)
      FS3Combat.emit_to_combat combatant.combat, message
    end


    def self.set_magic_armor_effects(combatant, spell)
      #Nothing uses this, but saving it in case I implement this.
      rounds = Global.read_config("spells", spell, "rounds")
      special = Global.read_config("spells", spell, "armor_specials")
      weapon = combatant.armor.before("+")
      weapon_specials = combatant.magic_armor_effects

      if combatant.magic_armor_effects.has_key?(armor)
        old_armor_specials = armor_specials[armor]
        armor_specials[armor] = old_armor_specials.merge!( special => rounds)
      else
        armor_specials[armor] = {special => rounds}
      end
      combatant.update(magic_armor_effects:armor_specials)
    end

    def self.magic_armor_specials(combatant, armor)
      #Returns all specials gained by magical means
      specials = []

      item_specials = Magic.magic_item_armor_specials(combatant)
      if item_specials
        specials = specials.concat item_specials
      end

      armor_effect_specials = combatant.magic_armor_effects[armor].keys if combatant.magic_armor_effects[armor]
      if armor_effect_specials
        specials = specials.concat armor_effect_specials
      end
      return specials
    end

    # def self.set_magic_armor(combatant, armor)
    #   #I don't think there's any need to do this over just FS3Combat.set_armor
    #   specials = Magic.magic_armor_specials(combatant, specials)
    #   combatant.update(armor_name: armor ? armor.titlecase : nil)
    #   combatant.update(armor_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
    #   message = t('fs3combat.armor_changed', :name => combatant.name, :armor => combatant.armor)
    #   FS3Combat.emit_to_combat combatant.combat, message, FS3Combat.npcmaster_text(combatant.name, enactor)
    # end



  end
end
