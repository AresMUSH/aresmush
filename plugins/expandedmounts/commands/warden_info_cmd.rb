module AresMUSH
  module ExpandedMounts
    class WardenInfoCmd
      include CommandHandler

      attr_accessor :target, :char

      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
        self.char = Character.named(self.target) || Mount.named(self.target)
        if !self.char
          characters = Character.all.select { |c| c.is_active? || c.is_npc?}
          characters.each do |c|
            self.char = c if self.target == c.demographic(:callsign)
          end
        elsif self.char.class == Mount
          self.char = char.bonded
        end

      end

      def check_permission
        return nil if self.target == enactor_name
      end

      def check_errors

        return "No character by that name." if !self.char
        return "That character is not a Warden." if !self.char.bonded
      end

      def handle

        ClassTargetFinder.with_a_character(self.char.name, client, enactor) do |model|

          template = WardenInfoTemplate.new(model)
          client.emit template.render
        end
      end

    end
  end
end