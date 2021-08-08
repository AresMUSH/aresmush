module AresMUSH
  module Who
    class WhoisCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? cmd.args.upcase : nil
      end
      
      def required_args
        [ self.name ]
      end
      
      def handle
        chars = Character.find_any_by_name(self.name)
        chars.concat Character.all.select { |c|( Ranks.military_name(c) ).upcase =~ /#{self.name}/ }


        nickname_field = Global.read_config("demographics", "nickname_field") || ""
        if (!nickname_field.blank?)
          chars.concat Character.all.select { |c| (c.demographic(nickname_field) || "").upcase == self.name }
        end
                
        if (chars.empty?)
          client.emit_failure t('db.object_not_found')
        else
          list = chars.uniq.map { |char| "#{char.name}: #{Profile.profile_title(char)}" }
          template = BorderedListTemplate.new list
          client.emit template.render
        end
      end      
    end

  end
end
