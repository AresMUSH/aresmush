module AresMUSH
  module Bbs
    class BbsEditCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name, :num, :new_text

      def initialize
        self.required_args = ['board_name', 'num']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("edit")
      end
      
      # TODO - Check Permissions
      
      def crack!
        cmd.crack!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=?(?<new_text>[^\=]+)?/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
        self.new_text = cmd.args.new_text
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post|          
          if (self.new_text.nil?)
            client.grab "bbs/edit #{self.board_name}/#{self.num}=#{post.message}"
          else
            post.message = self.new_text
            post.save!
            client.emit_success t('bbs.post_updated')
          end
        end
      end
    end
  end
end