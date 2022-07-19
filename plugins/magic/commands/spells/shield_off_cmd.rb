module AresMUSH
  module Magic
    class ShieldOffCmd
    # shield/off <shield>
      include CommandHandler

      attr_accessor :target, :shield

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)

        if args.arg2
          target_name = args.arg1
          self.target = Character.named(target_name)
          self.shield = titlecase_arg(args.arg2)
        else
          self.target = enactor
          self.shield = titlecase_arg(args.arg1)
        end
      end

      def check_errors
        Global.logger.info "SHIELD: #{self.shield}"
        return t('dispatcher.not_allowed') if (self.target != enactor && !enactor.has_permission?("view_bgs"))
        shields = Magic.spell_shields
        return t('magic.not_shield', :shield => self.shield) if !shields.include?(self.shield)
      end

      def handle
        if (self.shield == "Endure Fire" && target.endure_fire > 0)
          self.target.update(endure_fire: 0)

        elsif (self.shield == "Endure Cold" && target.endure_cold > 0)
          self.target.update(endure_cold: 0)

        elsif (self.shield == "Mind Shield" && target.mind_shield > 0)
          self.target.update(mind_shield: 0)
        else
          client.emit_failure t('magic.no_shield', :name => self.target.name, :spell => self.shield)
          return
        end

        message = t('magic.shield_wore_off', :name => self.target.name, :shield => self.shield)
        self.target.room.emit message
        client.emit_success t('magic.turned_shield_off', :name => self.target.name, :shield => self.shield)
        if self.target.room.scene
          Scenes.add_to_scene(self.target.room.scene, message)
        end

      end

    end
  end
end
