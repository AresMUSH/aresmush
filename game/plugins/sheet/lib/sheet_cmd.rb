module AresMUSH

  module Sheet
    class SheetCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :target, :page

      def initialize
        Sheet.build_renderers
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("sheet")
      end

      def crack!
        self.target = cmd.args.nil? ? client.name : trim_input(cmd.args)
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_permission
        return nil if self.target == client.name
        return nil if client.char.has_any_role?(Global.config['sheet']['roles']['can_view_sheets'])
        return nil if Global.config['sheet']['public_pages'].include?(self.page)
        return t('sheet.no_permission_to_view_page')
      end
      
      def check_page
        return t('sheet.invalid_page_number') if self.page <= 0
        return t('sheet.not_that_many_pages') if self.page > Sheet.sheet_renderers.count
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          renderer = Sheet.sheet_renderers[self.page - 1]
          client.emit renderer.render(model)
        end
      end
    end
  end
end
