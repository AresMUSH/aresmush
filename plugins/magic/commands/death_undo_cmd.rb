module AresMUSH
  module Magic
    class DeathUndoCmd
    #death/undo <name>
      include CommandHandler
 
      def check_errors
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        target = Character.find_one_by_name(cmd.args) || Mount.named(cmd.args)
        Magic.undead(target)
        Rooms.emit_to_room(enactor.room, t('magic.raised_dead', :name => enactor.name, :target => target.name))
      end

    end
  end
end
