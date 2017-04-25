module AresMUSH
  module Who
    class WhoisCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? cmd.args.upcase : nil
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'who'
        }
      end
      
      def handle
        char = Character.find_one_by_name(self.name)
        if (!char)
          char = Character.all.select { |c|( c.demographic('fullname') || "").upcase =~ /#{self.name}/ }.first
        end
        if (!char)
          char = Character.all.select { |c| (c.demographic('callsign') || "").upcase == self.name }.first
        end
        
        if (!char)
          client.emit_failure t('db.object_not_found')
        else
          client.emit_ooc "#{char.name}: #{Ranks::Api.military_name(char)}"
        end
      end      
    end

  end
end
