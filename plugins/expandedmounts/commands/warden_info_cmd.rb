module AresMUSH
  module ExpandedMounts
    class WardenInfoCmd
      include CommandHandler

      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end

      def check_permission
        return nil if self.target == enactor_name
      end

      def check_errors
        char = Character.named(self.target)
        return "No character by that name." if !char
        return "That character is not a Warden." if !char.bonded
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|

          template = WardenInfoTemplate.new(model)
          client.emit template.render
        end
      end

    end
  end
end