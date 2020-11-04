module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      attr_accessor :spell


      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def parse_args
        self.spel = titlecase_arg(cmd.args)
      end


      def handle
        if Chargen.approved_chars.select { |c| Magic.knows_spell?(c, self.spell) }
          client.emit c.name
        end

      end

    end
  end
end
