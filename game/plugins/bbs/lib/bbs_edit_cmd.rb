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
            
      def crack!
        cmd.crack_args!( /(?<name>[^\=]+)\/(?<num>[^\=]+)\=?(?<new_text>[^\=]+)?/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
        self.new_text = cmd.args.new_text
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post|
          
          if (!Bbs.can_edit_post(client.char, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
            
          if (self.new_text.nil?)
            client.grab "bbs/edit #{self.board_name}/#{self.num}=#{post.message}"
          else
            post.message = self.new_text
            post.mark_unread
            Global.client_monitor.emit_all_ooc t('bbs.new_edit', :subject => post.subject, :board => board.name, :author => client.name)
          end
        end
      end
    end
  end
end