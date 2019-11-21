module AresMUSH
  module Manage
    class FindCmd
      include CommandHandler

      attr_accessor :search_class, :name, :page

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        
        self.search_class = titlecase_arg(args.arg1)
        self.name = trim_arg(args.arg2)
        self.page = cmd.page
      end
      
      def required_args
        [ self.search_class ]
      end
      
      def handle
        begin
          c = AresMUSH.const_get(self.search_class)
          
          if (!Manage.can_manage_object?(enactor, c.new))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!self.name)
            objects = c.all
          else
            objects = c.all.select { |o| o.name_upcase =~ /#{self.name.upcase}/ }
          end
        rescue
          client.emit_failure t('manage.invalid_search_class')
          return
        end
          
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.dbref.ljust(6)} #{r.name}"}
        template = BorderedPagedListTemplate.new objects, self.page, 25, t('manage.find_results')
        client.emit template.render
      end
    end
  end
end
