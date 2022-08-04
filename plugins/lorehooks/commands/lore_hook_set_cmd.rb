module AresMUSH
  module Lorehooks
    class LoreHookSetCmd
      include CommandHandler
# `lorehook/set <name>=<lore_hook_name>/<lore_hook>` - Set a lore hook on a character.

      attr_accessor :lore_hook_name, :lore_hook_desc, :target

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        self.target = Character.named(args.arg1)
        self.lore_hook_name = trim_arg(args.arg2)
        self.lore_hook_desc = args.arg3
      end

      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         t('dispatcher.not_allowed')
      end

      def check_errors
        return t('db.object_not_found') if !self.target
      end


      def handle
        client.emit "#{self.target.name}'s current Lore hook: %R#{self.target.lore_hook_name}%R#{self.target.lore_hook_desc}"

        self.target.update(lore_hook_name: self.lore_hook_name)
        self.target.update(lore_hook_desc: self.lore_hook_desc)

        client.emit_success "You set #{self.target.name}'s new Lore Hook to: %R#{self.target.lore_hook_name}%R#{self.target.lore_hook_desc}"
      end

    end
  end
end
