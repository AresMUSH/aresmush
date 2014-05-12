module AresMUSH
  module Bbs
    class BbsReadCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include TemplateFormatters
      
      attr_accessor :name, :num

      def initialize
        self.required_args = ['name', 'num']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args =~ /[\/]/
      end
      
      def crack!
        cmd.crack!( /(?<name>[^\=]+)\/(?<num>.+)/)
        self.name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
      end
      
      def handle
        Bbs.with_a_post(self.name, self.num, client) do |board, post|      
          client.emit RendererFactory.post_renderer.render(board, post, client)
        end
      end      
    end
  end
end