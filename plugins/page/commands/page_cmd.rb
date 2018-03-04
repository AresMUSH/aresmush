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
        OnlineCharFinder.with_online_chars(self.names, client) do |results|
          recipients = results.map { |result| result.char }
          
          locked = recipients.select { |c| c.page_ignored.include?(enactor) }
          if (locked.any?)
            locked_names = locked.map { |c| c.name }
            client.emit_failure t('page.cant_page_ignored', :names => locked_names.join(" "))
            return
          end
          
          name = enactor.name_and_alias
          message = PoseFormatter.format(name, self.message)
          recipient_names = recipients.map { |r| r.name }.join(",")
        
          client.emit t('page.to_sender', 
            :autospace => enactor.page_autospace, 
            :color => enactor.page_color, 
            :recipients => recipient_names, 
            :message => message)
          results.each do |r|
            page_recipient(r.client, r.char, recipient_names, message)
          end
          
          enactor.update(last_paged: self.names)
        end
      end
      
      def page_recipient(other_client, other_char, recipients, message)
        if (other_char.page_do_not_disturb)
          client.emit_ooc t('page.recipient_do_not_disturb', :name => other_char.name)
        else          
          other_client.emit t('page.to_recipient', 
            :autospace => other_char.page_autospace, 
            :color => other_char.page_color, 
            :recipients => recipients, 
            :message => message)
          send_afk_message(other_client, other_char)
        end
        
        
        if (other_char.is_monitoring?(enactor))
          add_to_monitor(other_char, enactor.name, message)
        end
        
        if (enactor.is_monitoring?(other_char))
          add_to_monitor(enactor, other_char.name, message)
        end
      end
      
      def add_to_monitor(char, monitor_name, message)
        monitor = char.page_monitor
        
        if (monitor[monitor_name].count > 30)
          monitor[monitor_name].shift
        end
        monitor[monitor_name] << "#{Time.now} #{message}"
        char.update(page_monitor: monitor)
      end
            
      def send_afk_message(other_client, other_char)
        if (other_char.is_afk)
          afk_message = ""
          if (other_char.afk_display)
            afk_message = "(#{other_char.afk_display})"
          end
          afk_message = t('page.recipient_is_afk', :name => other_char.name, :message => afk_message)
          client.emit_ooc afk_message
          other_client.emit_ooc afk_message
        elsif (Status.is_idle?(other_client))
          time = TimeFormatter.format(other_client.idle_secs)
          afk_message = t('page.recipient_is_idle', :name => other_char.name, :time => time)
          client.emit_ooc afk_message
          other_client.emit_ooc afk_message
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
