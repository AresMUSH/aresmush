module AresMUSH
  module Randomscene
    class RandomSceneCmd
    # shield/off <shield>
      include CommandHandler 

      # attr_accessor :target, :shield

      # def parse_args
      #   self.name = titlecase_arg(cmd.args)
      # end
      #
      # def check_errors
      #   return t('randomscene.no_character') if !Character.named(self.name)
      # end

      def handle
        type = rand(2)

        if type == 1
          scenario = Global.read_config("randomscene", "scenario")
          msg = scenario.select
        else
          npc_list = Global.read_config("randomscene", "npcs")
          npc = npc_list.select
          action_list = Global.read_config("randomscene", "actions")
          action = action_list.select
          msg = "#{npc} #{action}"
        end
        client.emit_success msg

      end

    end
  end
end
