module AresMUSH
  module Forum
    class ForumCategoryCmd
      include CommandHandler
      
      attr_accessor :category_name

      def parse_args
        self.category_name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.category_name ]
      end
      
      def handle
        Forum.with_a_category(self.category_name, client, enactor) do |category|  
          template = ForumCategoryTemplate.new(category, enactor)
          client.emit template.render
        end
      end
    end
  end
end