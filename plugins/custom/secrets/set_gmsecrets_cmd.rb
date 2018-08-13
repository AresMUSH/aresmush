module AresMUSH
  module Custom
    class SetGMSecretsCmd
      include CommandHandler
# `gmsecrets/set <name>=<secret>` - Set a secret on a character.
      
      attr_accessor :gmsecrets, :char

        def parse_args
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.char = Character.find_one_by_name(args.arg1)
          self.gmsecrets = trim_arg(args.arg2)
        end
        
      def check_can_set
         return nil if enactor.has_permission?("view_bgs")
         return "Only admin can set secrets. See 'help secrets' for more info."
      end

        
      def handle   
        client.emit "#{self.char.name}'s current GM secrets: #{self.char.gmsecrets}"
        self.char.update(gmsecrets: self.gmsecrets)
        client.emit_success "You set #{self.char.name}'s new GM secrets to #{self.gmsecrets}"
      end          
        
    end
  end
end