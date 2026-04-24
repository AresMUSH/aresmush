module AresMUSH

  module FS3Skills
    class SheetCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor_name : titlecase_arg(cmd.args)
      end
      
      def check_permission
        return nil if self.target == enactor_name
        return nil if FS3Skills.can_view_sheets?(enactor)
        return nil if Global.read_config("fs3skills", "public_sheets")
        return t('fs3skills.no_permission_to_view_sheet')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = SheetTemplate.new(model, client.screen_reader, cmd.switch)
          client.emit template.render
        end
      end
    end
  end
end
