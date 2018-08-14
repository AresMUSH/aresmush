module AresMUSH
  module Custom
    class SpellModIsCmd
    #spell/modis <name>
      include CommandHandler
      attr_accessor :target

      def parse_args        
        self.target = Character.find_one_by_name(cmd.args)
      end
              
      def handle
        client.emit_success "#{target.name}'s spell modification is #{target.combatant.spell_mod}."
      end
    end
  end
end