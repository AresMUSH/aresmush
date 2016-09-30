module AresMUSH

  module FS3Skills
    class SheetCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target, :page
      
      def crack!
        self.target = !cmd.args ? enactor_name : trim_input(cmd.args)
        self.page = !cmd.page ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_permission
        return nil if self.target == enactor_name
        return nil if enactor.has_any_role?(Global.read_config("fs3skills", "roles", "can_view_sheets"))
        return nil if Global.read_config("fs3skills", "public_pages").include?(self.page)
        return t('fs3skills.no_permission_to_view_page')
      end
      
      def check_page
        return t('fs3skills.invalid_page_number') if self.page <= 0
        return t('fs3skills.not_that_many_pages') if self.page > FS3Skills.sheet_templates.count
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          template = FS3Skills.sheet_templates[self.page - 1].new(model, client)
          client.emit template.render
        end
      end
    end
  end
end
