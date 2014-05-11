module AresMUSH
  module Bbs
    class BbsBoardCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name

      def initialize
        self.required_args = ['name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("bbs")
        return false if !cmd.switch.nil?
        return false if cmd.args.nil?
        return false if cmd.args =~ /[=\/]/
        true
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        Bbs.with_a_board(self.name, client) do |board|
          title = board_title(board)
          posts = board.bbs_posts.each_with_index.map { |p, i| board_post_entry(p, i) }
          output = posts.join("%r")          
          client.emit BorderedDisplay.text(output, title, nil)
        end
      end
      
      def board_title(board)
        write_roles = board.write_roles.join(", ")
        read_roles = board.read_roles.join(", ")
        roles = right(t('bbs.board_roles', :read => read_roles, :write => write_roles),48)
        name = left(board.name, 30)        
        "%xh#{name}%xn#{roles}%r" +
        board.description +
        "%r%l2%r" +
        t('bbs.board_title') +
        "%r%l2"
      end
      
      def board_post_entry(post, index)
        client.emit t('bbs.unread_marker')
        num = "#{index+1}".rjust(2)
        unread = post.is_unread?(client.char) ? t('bbs.unread_marker') : " "
        unread = center(unread, 5)
        name = left(post.subject,30)
        author = left(post.author.name,25)
        date = post.created_at.strftime("%Y-%m-%d")
        "#{num} #{unread} #{name} #{author} #{date}"
      end
    end
  end
end