module AresMUSH
  module Rooms
    class MeetmeInviteCmd
      include CommandHandler

      attr_accessor :names

      def parse_args
        if (!cmd.args)
          self.names = []
        else
          self.names = cmd.args.split(" ")
        end
      end
      
      def required_args
        [ self.names ]
      end
      
      def check_target
        return t('rooms.meetme_target_missing') if self.names.empty?
        return nil
      end
      
      def check_approved
        return nil if Rooms.can_teleport?(enactor)
        return t('rooms.cant_meetme_if_newbie') if !enactor.is_approved?
        return nil
      end
      
      def handle
        success_names = []
        OnlineCharFinder.with_online_chars(self.names, client) do |results|
          results.each do |r|
            invitee = r.char
            if (invitee == enactor)
              client.emit_failure t('rooms.cant_meetme_self')
            elsif (!invitee.is_approved?)
              client.emit_failure t('rooms.cant_meetme_newbie', :name => invitee.name)
            else
              r.client.emit_ooc t('rooms.receive_meetme_invite', :name => enactor_name, :room => enactor_room.name)
              r.client.program[:meetme] = enactor.id
              success_names << invitee.name
              if (enactor_room.scene)
                Scenes.invite_to_scene(enactor_room.scene, invitee, enactor)
              end
            end
          end
        end
        if (!success_names.empty?)
          client.emit_success t('rooms.send_meetme_invite', :name => success_names.join(", "))
        end
      end
    end
  end
end
