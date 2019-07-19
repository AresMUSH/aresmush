module AresMUSH
  module Lorehooks
    class LoreHookPrefCmd
      include CommandHandler
# `lorehook/preference <preference>` - Set your Lore Hook preference.

      attr_accessor :preference, :target

      def parse_args
        self.target = Character.named(cmd.args)
        if !self.target
          self.preference = titlecase_arg(cmd.args)
        end
      end

      def handle
        preferences = ["None", "Item", "Pet", "Ancestry", "Storyteller"]
        if self.target
          client.emit_success "#{self.target.name}'s Lore Hook Preference: #{self.target.lore_hook_pref}"
        elsif preferences.include?(self.preference)
          enactor.update(lore_hook_pref: self.preference)
          client.emit_success "You have set your Lore Hook preference to #{self.preference}"
        else
          client.emit_failure "That is not a Lore Hook preference. Use one of the followig: #{preferences.join(", ")}."
        end
      end

    end
  end
end
