require 'byebug'
module AresMUSH
  module ExpandedMounts

    def self.dice_to_roll_for_ability(mount_or_rider, roll_params)
      #out of combat roll
      ability = roll_params.ability
      mount_or_rider.class == Mount ? mount = mount_or_rider : mount = mount_or_rider.bonded
      mount_or_rider.class == Character ? char = mount_or_rider : char = mount_or_rider.rider

      if ability == "Reflexes"
        mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "reflexes")
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      elsif ability == "Melee" ||  ability == "Brawl"
        mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "attack")
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      elsif  ability == "Composure"
        mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "composure")
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      elsif ability == "Stealth"
        mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "stealth")
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      elsif ability == "Alertness"
        mount_dice = Global.read_config("expandedmounts", mount.expanded_mount_type, "alertness")
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
      else
        #Don't average skills that mounts don't affect
        mount_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
        rider_dice = FS3Skills.dice_to_roll_for_ability(char, roll_params)
        no_log = true
      end

      dice = (rider_dice + mount_dice) / 2
      if !no_log
      Global.logger.info "TOTAL #{roll_params.ability.upcase} DICE: #{char.name}'s #{rider_dice} (mod: #{roll_params.modifier}) + #{mount.name}'s #{mount_dice} / 2 = #{dice}"
      end
      puts "Grabbing rider and mount dice: #{rider_dice} + #{mount_dice} / 2 = #{dice}"

      return dice
    end

    def self.bonded_name(char)
      return "BLEH"
      return char.bonded.name if char.bonded
      return nil
    end

    def self.mount_for_web(char)
      return false if !char.bonded
      mount = char.bonded

      damage = mount.damage.to_a.sort { |d| d.created_at }.map { |d| {
        date: d.ictime_str,
        description: d.description,
        original_severity: MushFormatter.format(FS3Combat.display_severity(d.initial_severity)),
        severity: MushFormatter.format(FS3Combat.display_severity(d.current_severity))
        }}

      return {
        name: mount.name,
        desc: mount.description,
        shortdesc: mount.shortdesc,
        details: mount.details,
        type: mount.expanded_mount_type,
        about: mount.about,
        damage: damage,
      }
    end

    def self.save_mount(char, char_data)
      puts "Char_data: #{char_data}"

        mount = char.bonded

        mount.update(name: char_data[:custom][:mythic_name].titlecase)
        mount.update(description: char_data[:custom][:mythic_desc])
        mount.update(shortdesc: char_data[:custom][:mythic_shortdesc])
        mount.update(about: char_data[:custom][:mythic_about])
    end
  end
end
