module AresMUSH
  module Pose
    class PageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :names, :message
      
      def want_command?(client, cmd)
        # It's a common mistake to type 'p' when you meant '+p' for a channel, but
        # never vice-versa.  So ignore any command that has a prefix. 
        return false if !cmd.prefix.nil?
        cmd.root_is?("page")
      end
      
      def crack!
        if (cmd.args.nil?)
          self.names = []
        elsif (cmd.args.include?("="))
          cmd.crack!(CommonCracks.arg1_equals_arg2)
          self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
          self.message = cmd.args.arg2
        else
          self.names = client.char.last_paged
          self.message = cmd.args
        end
      end
      
      def check_page_target
        return t('pose.page_target_missing') if self.names.empty?
        return nil
      end
      
      def handle
        OnlineCharFinder.with_online_chars(self.names, client) do |clients|
          name = client.char.name_and_alias
          message = PoseFormatter.format(name, self.message)
          receipients = clients.map { |r| r.name }.join(", ")
        
          client.emit_ooc t('pose.page_to_sender', :recipients => receipients, :message => message)
          clients.each do |c|
            c.emit_ooc t('pose.page_to_recipient', :recipients => receipients, :message => message)
            send_afk_message(c.char)
          end
        
          client.char.last_paged = self.names
          client.char.save!
        end
      end
      
      def send_afk_message(char)
        if (char.is_afk)
          afk_message = ""
          if (char.afk_message)
            afk_message = "(#{char.afk_message})"
          end
          client.emit_ooc t('pose.recipient_is_afk', :name => char.name, :message => afk_message)
        end
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
