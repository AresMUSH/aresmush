module AresMUSH
  module Bbs
    class BbsArchive
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
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
          Bbs.with_a_board(self.board_name, client) do |board|  
            board.bbs_posts.each_with_index do |post, i|
              Global.dispatcher.queue_timer(i, "BBS Archive") do
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