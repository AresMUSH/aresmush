module AresMUSH
  module Pose
    class PageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches

      attr_accessor :names, :message
      
      def want_command?(client, cmd)
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
        to_clients = []
        self.names.each do |name|
          result = OnlineCharFinder.find(name, client)
          if (!result.found?)
            client.emit_failure(result.error)
            return
          end
          to_clients << result.target
        end
        name = client.char.name_and_alias
        message = PoseFormatter.format(name, self.message)
        receipients = to_clients.map { |r| r.name }.join(", ")
        client.emit_ooc t('pose.page_to_sender', :recipients => receipients, :message => message)
        to_clients.each do |c|
          c.emit_ooc t('pose.page_to_recipient', :recipients => receipients, :message => message)
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
