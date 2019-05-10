module AresMUSH
  module Custom
    class MindshieldOffCmd
    # mindshield/off
      include CommandHandler

      attr_accessor :target

      def parse_args
        if cmd.args
          target_name = cmd.args
          self.target = Character.named(target_name)
        else
          self.target = enactor
        end
      end



      def check_errors
        return t('dispatcher.not_allowed') if (self.target != enactor && !FS3Skills.can_manage_abilities?(enactor))
      end

      def handle
          Global.logger.debug "Target #{self.target}"
        if self.target.mind_shield > 0
          self.target.update(mind_shield: 0)
          message = t('custom.mind_shield_wore_off', :name => self.target.name)
          self.target.room.emit message
          client.emit_success "You have turned #{self.target.name}'s Mind Shield off."
          if self.target.room.scene
            Scenes.add_to_scene(self.target.room.scene, message)
          end
        else
          client.emit_failure t('custom.no_mind_shield', :name => self.target.name)
        end
      end

    end
  end
end
