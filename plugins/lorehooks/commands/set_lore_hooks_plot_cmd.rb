module AresMUSH
  module Custom
    class LoreHookTypeCmd
      include CommandHandler
# `lorehook/setplot <name>=<lore_hook_plot>/` - Set a lore hook's plot on a character.

      attr_accessor :lore_hook_type, :target

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target = Character.find_one_by_name(args.arg1)
          self.lore_hook_type = titlecase_arg(args.arg2)
        end

      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         t('dispatcher.not_allowed')
      end

      def check_errors
        return t('db.object_not_found') if !self.target
        types = ["Ancestry", "Item", "Pet"]
        return "%xrInvalid type. Use ancestry, item, or pet.%xn" if !types.include?(self.lore_hook_type)
      end

      def handle
        self.target.update(lore_hook_type: self.lore_hook_type)
        client.emit_success "You set #{self.target.name}'s Lore Hook type to #{self.target.lore_hook_type}"
      end

    end
  end
end
