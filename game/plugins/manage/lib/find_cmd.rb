module AresMUSH
  module Manage
    class FindCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :search_class, :name
      
      def want_command?(client, cmd)
        cmd.root_is?("find")
      end
      
      def crack!
        cmd.crack!(/(?<search_class>[^\=]+)\=?(?<name>.+)?/)
        
        self.search_class = trim_input(cmd.args.search_class).titleize
        self.name = trim_input(cmd.args.name)
      end

      def check_can_build
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end
      
      def handle
        begin
          c = get_search_class
          if (self.name.nil?)
            objects = c.all
          else
            objects = c.find_all_by_name(self.name)
          end
        rescue
          client.emit_failure t('manage.invalid_search_class')
          return
        end
          
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.id} #{r.name}"}
        client.emit BorderedDisplay.list(objects, t('manage.find_results'))
      end
      
      def get_search_class
        AresMUSH.const_get(self.search_class)
      end
      
    end
  end
end
