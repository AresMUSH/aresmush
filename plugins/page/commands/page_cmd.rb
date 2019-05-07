module AresMUSH
  module Page
    class PageCmd
      include CommandHandler

      attr_accessor :names, :message
      
      def parse_args
        if (!cmd.args)
          self.names = []
        elsif (cmd.args.start_with?("="))
          self.names = enactor.last_paged
          self.message = cmd.args.after("=")
        elsif (cmd.args.include?("="))
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          
          # Catch the common mistake of last-paging someone a link.
          if (args.arg1 && (args.arg1.include?("http://") || args.arg1.include?("https://")) )
            self.names = enactor.last_paged
            self.message = "#{args.arg1}=#{args.arg2}"
          else
            self.names = list_arg(args.arg1)
            self.message = trim_arg(args.arg2)
          end
        else
          self.names = enactor.last_paged
          self.message = cmd.args
        end
      end
      
      def check_page_target
        return t('page.target_missing') if !self.names || self.names.empty?
        return nil
      end
      
      def handle
        recipients = []
        
        if self.names.count == 1 && self.names[0].upcase == enactor.name_upcase
          client.emit_failure t('page.cant_page_just_yourself')
          return
        end
        
        self.names.each do |name|
          char = Character.find_one_by_name(name)
          if (!char)
            client.emit_failure t('page.invalid_recipient', :name => name)
            return
          end
          
          if (char.page_ignored.include?(enactor))
            client.emit_failure t('page.cant_page_ignored', :name => name)
            return
          end
          
          if (char != enactor)
            recipients << char
          end
        end
      
        Page.send_page(enactor, recipients, self.message, client)
        
        enactor.update(last_paged: self.names)
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
