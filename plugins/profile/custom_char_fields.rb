module AresMUSH
  module Profile
    class CustomCharFields

      # Gets custom fields for display in a character profile.
      #
      # @param [Character] char - The character being requested.
      # @param [Character] viewer - The character viewing the profile. May be nil if someone is viewing
      #    the profile without being logged in.
      #
      # @return [Hash] - A hash containing custom fields and values.
      #    Ansi or markdown text strings must be formatted for display.
      # @example
      #    return { goals: Website.format_markdown_for_html(char.goals) }
      def self.get_fields_for_viewing(char, viewer)
        spells = Magic.spell_list_all_data(char.spells_learned)
        return {
          comps: Compliments.get_comps(char),
          spells: spells,
          major_spells: Magic.major_school_spells(char, spells),
          minor_spells: Magic.minor_school_spells(char, spells),
          other_spells: Magic.other_spells(char, spells),
          major_school: char.major_schools,
          minor_school: char.minor_schools,
          magic_items: Magic.get_magic_items(char),
          potions: Magic.get_potions(char),
          potions_creating: Magic.get_potions_creating(char),
          lore_hook_name: char.lore_hook_name,
          lore_hook_desc: char.lore_hook_desc,
          lore_hook_item: Lorehooks.lore_hook_type(char)[:item],
          lore_hook_pet: Lorehooks.lore_hook_type(char)[:pet],
          mythic_name: char.bonded.name || nil,
        }
      end

      # Gets custom fields for the character profile editor.
      #
      # @param [Character] char - The character being requested.
      # @param [Character] viewer - The character editing the profile.
      #
      # @return [Hash] - A hash containing custom fields and values.
      #    Multi-line text strings must be formatted for editing.
      # @example
      #    return { goals: Website.format_input_for_html(char.goals) }
      def self.get_fields_for_editing(char, viewer)
        return {}
      end

      # Gets custom fields for character creation (chargen).
      #
      # @param [Character] char - The character being requested.
      #
      # @return [Hash] - A hash containing custom fields and values.
      #    Multi-line text strings must be formatted for editing.
      # @example
      #    return { goals: Website.format_input_for_html(char.goals) }
      def self.get_fields_for_chargen(char)
        return {
          major_school: Website.format_input_for_html(char.major_schools.join()),
          major_schools: Global.read_config("magic", "major_schools"),
          minor_school: Website.format_input_for_html(char.minor_schools.join()),
          minor_schools: Global.read_config("magic", "minor_schools"),
          mage_cg_spells: Magic.mage_cg_spells(char),
          mythic_cg_spells: Magic.mythic_cg_spells(char),
          mage_starting_spells: Magic.mage_starting_spells(char),
          mythic_starting_spells: Magic.mythic_starting_spells(char),
          mount_name: ExpandedMounts.mount_name(char),
          mount_types: ["Dragon", "Griffon", "Roc", "Pantherine", "Lupine", "Pegasus"],
          mount_type: ExpandedMounts.expanded_mount_type(char),
          mount_desc: ExpandedMounts.mount_desc(char),
          mount_shortdesc: ExpandedMounts.mount_shortdesc(char),
          lore_hook_pref: { value: char.lore_hook_pref, desc: char.lore_hook_pref },
          lore_hook_prefs: Lorehooks.lore_hook_cg_prefs,
          magic_blurb: Global.read_config("magic", "cg_blurb"),
          mythic_blurb: Global.read_config("expandedmounts", "cg_blurb"),
          mythic_magic_blurb: Global.read_config("expandedmounts", "magic_blurb"),
          lorehook_blurb: Global.read_config("magic", "lorehook_blurb"),
        }
      end

      # Saves fields from profile editing.
      #
      # @param [Character] char - The character being updated.
      # @param [Hash] char_data - A hash of character fields and values. Your custom fields
      #    will be in char_data[:custom]. Multi-line text strings should be formatted for MUSH.
      #
      # @return [Array] - A list of error messages. Return an empty array ([]) if there are no errors.
      # @example
      #        char.update(goals: Website.format_input_for_mush(char_data[:custom][:goals]))
      #        return []
      def self.save_fields_from_profile_edit(char, char_data)

        return []
      end

      # Saves fields from character creation (chargen).
      #
      # @param [Character] char - The character being updated.
      # @param [Hash] chargen_data - A hash of character fields and values. Your custom fields
      #    will be in chargen_data[:custom]. Multi-line text strings should be formatted for MUSH.
      #
      # @return [Array] - A list of error messages. Return an empty array ([]) if there are no errors.
      # @example
      #        char.update(goals: Website.format_input_for_mush(chargen_data[:custom][:goals]))
      #        return []
      def self.save_fields_from_chargen(char, chargen_data)
        errors = []
        Magic.save_major_school(char, chargen_data[:custom][:major_school]) if chargen_data[:custom][:major_school]
        Magic.save_minor_school(char, chargen_data[:custom][:minor_school]) if chargen_data[:custom][:minor_school]
        starting_spells = Magic.starting_spell_names(chargen_data[:custom])
        Magic.save_starting_spells(char, starting_spells)
        errors.concat ExpandedMounts.save_mount(char, chargen_data)
        char.update(lore_hook_pref: chargen_data[:custom][:lore_hook_pref][:value])
        puts "Starting spell names: #{Magic.starting_spell_names(chargen_data[:custom][:starting_spells])}"
        errors.concat Magic.check_cg_spell_errors(char)
        puts "Errors: #{errors}"
        return errors
      end

    end
  end
end