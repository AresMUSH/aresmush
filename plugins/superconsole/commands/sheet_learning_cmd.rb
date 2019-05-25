module AresMUSH

  module SuperConsole
    class SheetLearnCmd
      include CommandHandler

      attr_accessor :target

      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end

      def check_permission
        return nil if self.is_admin?
        return t('superconsole.learn_error')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = LearnTemplate.new(model, client)
          client.emit template.render
        end
      end
    end
  end
end
