module AresMUSH
  module Bbs
    class BbsArchive
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include TemplateFormatters
      
      attr_accessor :board_name

      def initialize
        self.required_args = ['board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("archive")
      end
      
      def crack!
        self.board_name = titleize_input(cmd.args)
      end
      
      def handle
        client.emit_ooc t('bbs.starting_archive')
        Bbs.with_a_board(self.board_name, client) do |board|  
          if board.bbs_posts.count > 30
            client.emit_failure t('bbs.too_much_for_archive')
            return
          end
          
          board.bbs_posts.each_with_index do |post, i|
            Global.dispatcher.queue_timer(i, "BBS Archive", client) do
              Global.logger.debug "Logging bbpost #{post.id} from #{board.name}."
              date = OOCTime.local_long_timestr(client, post.created_at)
              author = post.author.nil? ? t('bbs.deleted_author') : post.author.name
              text = "%R%R+ #{post.subject}"
              text << "%r//#{author} -- #{date}//"
              text << "%R%r#{post.message}"
              post.bbs_replies.each do |reply|
                rauthor = reply.author.nil? ? t('bbs.deleted_author') : reply.author.name
                rdate = OOCTime.local_long_timestr(client, reply.created_at)
                text << "%R%R//#{t('bbs.reply_title', :name => rauthor, :date => rdate)}//"
                text << "%R%R#{reply.message}"
              end
              client.emit text
            end
          end
        end
      end      
    end
  end
end