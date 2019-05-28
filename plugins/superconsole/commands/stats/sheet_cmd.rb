module AresMUSH

  module SuperConsole
    class SheetCmd
      include CommandHandler

      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end

      def check_permission
        return nil if self.target == enactor_name
        return nil if SuperConsole.can_view_sheets?(enactor)
        return t('superconsole.sheet_error')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = SheetTemplate.new(model, client)
          client.emit template.render
        end
      end
    end
  end
end
