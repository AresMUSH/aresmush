module AresMUSH
  module Pose
    class PageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :names, :message
      
      def want_command?(client, cmd)
        cmd.root_is?("page")
      end
      
      def crack!
        if (cmd.args.nil?)
          self.names = []
        elsif (cmd.args.include?("="))
          cmd.crack!(/(?<names>[^\=]+)\=(?<message>.+)/)
          self.names = cmd.args.names.split(" ")
          self.message = cmd.args.message
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
        chars = []
        self.names.each do |name|
          result = ClassTargetFinder.find(name, Character, client)
          if (!result.found?)
            client.emit_failure(t('pose.page_target_not_found', :name => name))
            return
          end
          chars << result.target
        end
        message = PoseFormatter.format(client.name, self.message)
        receipients = chars.map { |r| r.name }.join(", ")
        client.emit_ooc t('pose.page_to_sender', :recipients => receipients, :message => message)
        chars.each do |c|
          to_client = Global.client_monitor.find_client(c)
          to_client.emit_ooc t('pose.page_to_recipient', :name => client.name, :recipients => receipients, :message => message)
        end
        client.char.last_paged = self.names
        client.char.save!
      end
      
      def log_command
        # Don't log pages
      end
    end
  end
end
