module AresMUSH
  module Bbs
    class BbsEditCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :board_name, :num, :new_text

      def crack!
        cmd.crack_args!( /(?<name>[^\/]+)\/(?<num>[^\=]+)\=?(?<new_text>.+)?/)
        self.board_name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
        self.new_text = cmd.args.new_text
      end
      
      def required_args
        {
          args: [ self.board_name, self.num ],
          help: 'bbs'
        }
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client, enactor) do |board, post|
          
          if (!Bbs.can_edit_post(enactor, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
            
          if (!self.new_text)
            Utils::Api.grab client, enactor, "bbs/edit #{self.board_name}/#{self.num}=#{post.message}"
          else
            post.update(message: self.new_text)
            post.mark_unread
            Global.client_monitor.emit_all_ooc t('bbs.new_edit', :subject => post.subject, 
            :board => board.name, 
            :reference => post.reference_str,
            :author => enactor_name)
          end
        end
      end
    end
  end
end