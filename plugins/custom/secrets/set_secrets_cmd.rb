module AresMUSH
  module Custom
    class SetSecretsCmd
      include CommandHandler
# `secrets/set <name>=<secret>` - Set a secret on a character.
      
      attr_accessor :secrets, :char

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.char = Character.find_one_by_name(args.arg1)
          self.secrets = trim_arg(args.arg2)
        end
        
      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         return "Only admin can set secrets. See 'help secrets' for more info."
      end

        
      def handle   
        client.emit "#{self.char.name}'s current secrets: #{self.char.secrets}"
        self.char.update(secrets: self.secrets)
        client.emit_success "You set #{self.char.name}'s new secrets to #{self.secrets}"
      end          
        
    end
  end
end