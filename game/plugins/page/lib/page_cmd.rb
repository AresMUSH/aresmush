module AresMUSH
  module Page
    class PageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :names, :message
      
      def want_command?(client, cmd)
        # It's a common mistake to type 'p' when you meant '+p' for a channel, but
        # never vice-versa.  So ignore any command that has a prefix. 
        return false if !cmd.prefix.nil?
        cmd.root_is?("page") && cmd.switch.nil?
      end
      
      def crack!
        if (cmd.args.nil?)
          self.names = []
        elsif (cmd.args.start_with?("="))
          self.names = client.char.last_paged
          self.message = cmd.args.after("=")
        elsif (cmd.args.include?("="))
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
          self.message = cmd.args.arg2
        else
          self.names = client.char.last_paged
          self.message = cmd.args
        end
      end
      
      def check_page_target
        return t('page.target_missing') if self.names.empty?
        return nil
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |clients|
          name = client.char.ooc_name
          message = PoseFormatter.format(name, self.message)
          recipients = clients.map { |r| r.char.ooc_name }.join(", ")
        
          client.emit_ooc t('page.to_sender', :recipients => recipients, :message => message)
          clients.each do |c|
            page_recipient(c, recipients, message)
          end
        
          client.char.last_paged = self.names
          client.char.save!
        end
      end
      
      def page_recipient(other_client, recipients, message)
        if (other_client.char.do_not_disturb)
          client.emit_ooc t('page.recipient_do_not_disturb', :name => other_client.name)
          Mail.send_mail([other_client.name], 
              t('page.missed_page_subject', :name => client.name), 
              t('page.missed_page_body', :name => client.name, :message => message), 
              client)
        else          
          other_client.emit_ooc t('page.to_recipient', :recipients => recipients, :message => message)
          send_afk_message(other_client)
        end
      end
      
      def send_afk_message(other_client)
        char = other_client.char
        if (char.is_afk)
          afk_message = ""
          if (char.afk_message)
            afk_message = "(#{char.afk_message})"
          end
          client.emit_ooc t('page.recipient_is_afk', :name => char.name, :message => afk_message)
        elsif (Status.is_idle?(other_client))
          time = TimeFormatter.format(other_client.idle_secs)
          client.emit_ooc t('page.recipient_is_idle', :name => char.name, :time => time)
        end
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
