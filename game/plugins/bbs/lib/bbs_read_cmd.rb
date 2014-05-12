module AresMUSH
  module Bbs
    class BbsReadCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name, :num

      def initialize
        self.required_args = ['name']
        self.required_args = ['num']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        # TODO TODO - There's got to be a better way to do this.
        return false if !cmd.root_is?("bbs")
        return false if !cmd.switch.nil?
        return false if cmd.args.nil?
        return false if cmd.args !~ /[\/]/
        return false if cmd.args =~ /[\=]/
        true
      end
      
      def crack!
        cmd.crack!( /(?<name>[^\=]+)\/(?<num>.+)/)
        self.name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
      end
      
      def handle
        Bbs.with_a_post(self.name, self.num, client) do |board, post|          
          title = post_title(board, post)
          client.emit BorderedDisplay.text(post.message, title, nil)
        end
      end
      
      def post_title(board, post)
        name = left(board.name, 30)
        author = right(post.author.name, 47)
        subject = left(post.subject, 30)
        date = right(post.created_at.strftime("%Y-%m-%d"), 47)
        "#{name} #{author}%r#{subject} #{date}%r%l2"
      end
    end
  end
end