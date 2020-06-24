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
        type = rand(3)

        if type == 1
          scenario = Global.read_config("randomscene", "scenarios")
          msg = "%xmRandom scenario: #{scenario.sample}%xn"
        elsif type == 2
          room_list = Room.all.select { |r| r.room_type == "IC" }
          room = room_list.sample
          word_list = Global.read_config("randomscene", "words")
          word = word_list.sample
          msg = "%xmYour prompt is #{word}. Your location is #{room.area.name}/#{room.name}.%xn"
        else
          npc_list = Global.read_config("randomscene", "npcs")
          npc = npc_list.sample
          action_list = Global.read_config("randomscene", "actions")
          action = action_list.sample
          msg = "%xmRandom scenario: #{npc} #{action}.%xn"
        end
        client.emit msg

      end

    end
  end
end
