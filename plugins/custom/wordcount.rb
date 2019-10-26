module AresMUSH
  module Custom
    class WordcountCmd
      include CommandHandler

      attr_accessor :character

      def parse_args
        self.character = !cmd.args ? enactor : Character.find_one_by_name(cmd.args)
      end
      
      def required_args
        [ self.character ]
      end

      def handle
        count = character.pose_word_count
        charname = character.name
        client.emit_ooc "#{charname}'s current word count:%xn #{count} words."
      end
    end
  end
end
