module AresMUSH
  module Page
    class PageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches

      attr_accessor :names, :message
      
      def crack!
        if (cmd.args.nil?)
          self.names = []
        elsif (cmd.args.start_with?("="))
          self.names = enactor.last_paged
          self.message = cmd.args.after("=")
        elsif (cmd.args.include?("="))
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          
          # Catch the common mistake of last-paging someone a link.
          if (cmd.args.arg1 && cmd.args.arg1.include?("http://"))
            self.names = enactor.last_paged
            self.message = "#{cmd.args.arg1}=#{cmd.args.arg2}"
          else
            self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
            self.message = cmd.args.arg2
          end
        else
          self.names = enactor.last_paged
          self.message = cmd.args
        end
      end
      
      def check_page_target
        return t('page.target_missing') if self.names.empty?
        return nil
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |clients|
          name = enactor.name
          message = PoseFormatter.format(name, self.message)
          recipients = clients.map { |r| r.char.name_and_alias }.join(", ")
        
          client.emit t('page.to_sender', :autospace => Pose::Api.autospace(enactor), :color => page_color, :recipients => recipients, :message => message)
          clients.each do |c|
            page_recipient(c, recipients, message)
          end
        
          enactor.last_paged = self.names
          enactor.save!
        end
      end
      
      def page_recipient(other_client, recipients, message)
        if (other_enactor.do_not_disturb)
          client.emit_ooc t('page.recipient_do_not_disturb', :name => other_enactor_name)
          Mail::Api.send_mail([other_enactor_name], 
              t('page.missed_page_subject', :name => enactor_name), 
              t('page.missed_page_body', :name => enactor_name, :message => message), 
              client)
        else          
          other_client.emit t('page.to_recipient', :autospace => Pose::Api.autospace(other_enactor), :color => page_color, :recipients => recipients, :message => message)
          send_afk_message(other_client)
        end
      end
      
      def send_afk_message(other_client)
        char = other_enactor
        if (char.is_afk)
          afk_message = ""
          if (Status::Api.afk_message(char))
            afk_message = "(#{Status::Api.afk_message(char)})"
          end
          client.emit_ooc t('page.recipient_is_afk', :name => char.name, :message => afk_message)
        elsif (Status::Api.is_idle?(other_client))
          time = TimeFormatter.format(other_client.idle_secs)
          client.emit_ooc t('page.recipient_is_idle', :name => char.name, :time => time)
        end
      end
      
      def page_color
        Global.read_config("page", "page_color")
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
