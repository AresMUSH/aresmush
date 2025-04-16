module AresMUSH
  module Page
    class PageReplyCmd
      include CommandHandler

      attr_accessor :num, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        
        if (args.arg2)
          self.num = integer_arg(args.arg1)
          self.message = trim_arg(args.arg2)
        else
          self.num = 1
          self.message = trim_arg(args.arg1)
        end
      end
      
      def required_args
        [ self.num, self.message ]
      end
      
      def check_guest
        return t('dispatcher.not_allowed') if enactor.has_any_role?("guest")
        return nil
      end
      
      def handle
        
        thread = enactor.sorted_page_threads[self.num - 1]
        if (!thread)
          client.emit_failure t('page.invalid_thread')
          return
        end
        
        names = thread.names
        result = Page.get_receipients(names, enactor)
        if (result[:error])
          client.emit_failure result[:error]
          return
        end
        
        Page.send_page(enactor, result[:recipients], self.message, client)
        
        enactor.update(last_paged: names)
      end
    end
  end
end
