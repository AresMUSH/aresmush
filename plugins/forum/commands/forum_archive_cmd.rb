module AresMUSH
  module Forum
    class ForumArchive
      include CommandHandler
      
      attr_accessor :category_name
      
      def parse_args
        self.category_name = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.category_name ]
      end
      
      def handle
        client.emit_ooc t('forum.starting_archive')

        Global.dispatcher.spawn("Archiving BBS", client) do
          Forum.with_a_category(self.category_name, client, enactor) do |category|  
            posts = category.sorted_posts
            posts.each_with_index do |post, seconds|
              Global.dispatcher.queue_timer(seconds, "Forum archive #{category.name}", client) do
                Global.logger.debug "Logging post #{post.id} from #{category.name}."
                template = ArchiveTemplate.new([post], enactor)
                client.emit template.render
              end
            end
            Global.dispatcher.queue_timer(posts.count + 2, "Forum archive", client) do
              client.emit_success t('global.done')
            end
          end
        end
      end      
    end
  end
end