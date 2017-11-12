module AresMUSH
  class VictoryKill < Ohm::Model
    reference :character, "AresMUSH::Character"
    reference :scene, "AresMUSH::Scene"   
    attribute :victory 
  end
  
  class Character
    collection :kills, "AresMUSH::VictoryKill"
  end

  module Custom
    class KillCmd
      include CommandHandler
      
      attr_accessor :scene_num, :name, :victory
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
        
        self.name = args.arg1
        self.scene_num = args.arg2
        self.victory = args.arg3
      end
      
      def check_admin
        return t('dispatcher.not_allowed') if (!enactor.is_admin?)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          scene = Scene[self.scene_num]
          if (!scene)
            client.emit_failure "Scene not found."
            return
          end
          
          VictoryKill.create(victory: self.victory, character: model, scene: scene)
          client.emit_success "Kill recorded. #{model.name} now has #{model.kills.count} kills."
        end
      end
    end
  end
end
