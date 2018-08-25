module AresMUSH
  module Custom
    class DeathUndoCmd
    #death/undo <name>
      include CommandHandler

      def check_errors
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        target = Character.find_one_by_name(cmd.args)
        Custom.undead(target)
        Rooms.emit_to_room(enactor.room, t('custom.raised_dead', :name => enactor.name, :target => target.name))
      end

    end
  end
end
