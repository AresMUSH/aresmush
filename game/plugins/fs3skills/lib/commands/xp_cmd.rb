module AresMUSH

  module FS3Skills
    class XpCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :target

      def crack!
        self.target = !cmd.args ? enactor_name : trim_input(cmd.args)
      end

      def check_permission
        return nil if self.target == enactor_name
        return nil if enactor.has_any_role?(Global.read_config("fs3skills", "roles", "can_view_sheets"))
        return t('dispatcher.not_allowed')
      end

      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = XpTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
