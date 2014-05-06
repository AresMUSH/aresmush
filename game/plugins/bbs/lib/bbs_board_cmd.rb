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
          title ="BBS #{board.name}%r#{board.description}%rwrite: #{board.write_roles.join(", ")} read: #{board.read_roles.join(", ")}"
          posts = board.bbs_posts.each_with_index.map { |p, i| board_post_entry(p, i) }
          client.emit BorderedDisplay.list(posts, title)
        end
      end
      
      def board_post_entry(post, index)
        client.emit t('bbs.unread_marker')
        num = "#{index+1}".rjust(2)
        unread = post.is_unread?(client.char) ? t('bbs.unread_marker') : "   "
        name = left(post.subject,20)
        author = post.author.name
        "#{num} #{unread} #{name} #{author}"
      end
    end
  end
end