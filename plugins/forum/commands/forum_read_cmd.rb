module AresMUSH
  module Forum
    class ForumReadCmd
      include CommandHandler
      
      attr_accessor :category_name, :num
      
      def parse_args
        args = cmd.parse_args( /(?<name>[^\=]+)\/(?<num>.+)/)
        self.category_name = titlecase_arg(args.name)
        self.num = trim_arg(args.num)
      end
      
      def required_args
        [ self.category_name, self.num ]
      end
      
      def handle
        if (self.num.downcase == 'u')
          Forum.with_a_category(self.category_name, client, enactor) do |category|  
            unread = category.unread_posts(enactor)
            if (unread.count == 0)
              client.emit_success t('forum.no_new_posts')
              return
            end
            
            unread.each do |u|
              Global.dispatcher.queue_command(client, Command.new("forum #{self.category_name}/#{u.post_index}"))
            end
          end
          return
        end
        
        Forum.with_a_post(self.category_name, self.num, client, enactor) do |category, post|      

          template = PostTemplate.new(category, post, enactor)
          client.emit template.render

          Forum.mark_read_for_player(enactor, post)
          client.program[:last_forum_post] = post
        end
      end      
    end
  end
end