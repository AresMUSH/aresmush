module AresMUSH
  module Custom
    class FatigueCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
        self.name = !cmd.args ? enactor : Character.find_one_by_name(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
     
      def handle
        fatigue = name.fatigue
        if !fatigue
          fatigue = 0
        end
        client.emit_ooc("#{name.name}'s Fatigue: #{fatigue} / 7")
      end
    end
  end
end
