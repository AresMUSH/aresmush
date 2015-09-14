module AresMUSH

  module FS3Sheet
    class SheetCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :target, :page
      
      def want_command?(client, cmd)
        cmd.root_is?("sheet")
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_permission
        return nil if self.target == client.name
        return nil if client.char.has_any_role?(Global.read_config("sheet", "roles", "can_view_sheets"))
        return nil if Global.read_config("sheet", "public_pages").include?(self.page)
        return t('sheet.no_permission_to_view_page')
      end
      
      def check_page
        return t('sheet.invalid_page_number') if self.page <= 0
        return t('sheet.not_that_many_pages') if self.page > FS3Sheet.sheet_templates.count
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template = FS3Sheet.sheet_templates[self.page - 1].new(model, client)
          template.render
        end
      end
    end
  end
end
