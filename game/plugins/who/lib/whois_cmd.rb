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
        chars = Character.find_any_by_name(self.name)
        chars.concat Character.all.select { |c|( c.demographic('fullname') || "").upcase =~ /#{self.name}/ }
        chars.concat Character.all.select { |c| (c.demographic('callsign') || "").upcase == self.name }
        
        if (chars.empty?)
          client.emit_failure t('db.object_not_found')
        else
          list = chars.uniq.map { |char| "#{char.name}: #{Ranks::Api.military_name(char)}" }
          template = BorderedListTemplate.new list
          client.emit template.render
        end
      end      
    end

  end
end
