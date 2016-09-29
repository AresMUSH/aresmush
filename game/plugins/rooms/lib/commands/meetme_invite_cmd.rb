module AresMUSH
  module Rooms
    class MeetmeInviteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :names
      
      def initialize(client, cmd, enactor)
        self.required_args = ['names']
        self.help_topic = 'meetme'
        super
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
      
      def check_approved
        return nil if Rooms.can_teleport?(enactor)
        return t('rooms.cant_meetme_if_newbie') if !enactor.is_approved
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
          target = result.target
          if (target == client)
            client.emit_failure t('rooms.cant_meetme_self')
            return
          end
          if (!target.char.is_approved && !Rooms.can_teleport?(target.char))
            client.emit_failure t('rooms.cant_meetme_newbie', :name => target.name)
            return
          end
          to_clients << target
        end
        
        to_clients.each do |c|
          c.emit_ooc t('rooms.receive_meetme_invite', :name => enactor_name, :room => enactor_room.name)          
          c.program[:meetme] = client
        end
        client.emit_success t('rooms.send_meetme_invite', :name => self.names.join(", "))
      end
    end
  end
end
