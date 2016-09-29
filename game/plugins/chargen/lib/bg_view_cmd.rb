module AresMUSH
  module Chargen
    class BgCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :target, :page
      
      def crack!
        self.target = cmd.args.nil? ? enactor_name : trim_input(cmd.args)
        self.page = cmd.page.nil? ? 1 : trim_input(cmd.page).to_i
      end
      
      def check_permission
        return nil if self.target == enactor_name
        return nil if Chargen.can_view_bgs?(enactor)
        return t('chargen.no_permission_to_view_bg')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client) do |model|
          template = BgTemplate.new(model)
          client.emit template.render
        end
      end
    end
  end
end
