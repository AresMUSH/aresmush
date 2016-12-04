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

  Character.all.each { |c| c.update(shortcuts: {} )}
  
  FS3Attribute.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3ActionSkill.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3BackgroundSkill.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3Language.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
        client.emit_success "Done!"
      end

    end
  end
end
