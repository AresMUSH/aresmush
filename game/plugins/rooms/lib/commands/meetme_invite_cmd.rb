module AresMUSH
  module Rooms
    class MeetmeInviteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :names
      
      def initialize
        self.required_args = ['names']
        self.help_topic = 'meetme'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("meetme") && cmd.switch.nil?
      end
      
      def crack!
        if (cmd.args.nil?)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end
      
      def check_target
        return t('rooms.meetme_target_missing') if self.names.empty?
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
          if (result.target == client)
            client.emit_failure t('rooms.cant_meetme_self')
            return
          end
          to_clients << result.target
        end
        
        to_clients.each do |c|
          c.emit_ooc t('rooms.receive_meetme_invite', :name => client.name)          
          c.program[:meetme] = client
        end
        client.emit_success t('rooms.send_meetme_invite', :name => self.names.join(", "))
      end
    end
  end
end
