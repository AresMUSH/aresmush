module AresMUSH

  module FS3Skills
    class SheetCmd
      include CommandHandler
      
      attr_accessor :target
      
      def parse_args
        self.target = !cmd.args ? enactor_name : trim_arg(cmd.args)
      end
      
      def check_permission
        return nil if self.target == enactor_name
        return nil if FS3Skills.can_view_sheets?(enactor)
        return nil if Global.read_config("fs3skills", "public_pages").include?(cmd.page)
        return t('fs3skills.no_permission_to_view_page')
      end
      
      def check_page
        return t('fs3skills.invalid_page_number') if cmd.page <= 0
        return t('fs3skills.not_that_many_pages') if cmd.page > FS3Skills.sheet_templates.count
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = FS3Skills.sheet_templates[cmd.page - 1].new(model, client)
          client.emit template.render
        end
      end
    end
  end
end
