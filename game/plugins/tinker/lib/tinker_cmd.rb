module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
            
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.can_manage_game?
        return nil
      end
      
      def handle
        #Damage.all.each { |d| client.emit d.inspect }
        #Npc.all.each { |d| client.emit d.inspect }
        #Combatant.all.each { |d| client.emit d.inspect }
     # Damage.all.each { |d| client.emit d.delete }
        # Put whatever you need to do here.
        

        client.emit_success "Done!"
      end

    end
  end
end
