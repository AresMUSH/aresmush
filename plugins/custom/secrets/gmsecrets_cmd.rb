module AresMUSH
  module Custom
    class GMSecretsCmd
      include CommandHandler
      
      attr_accessor :name
      
        def parse_args
            self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
        end
        
        def check_can_view
            return nil if enactor.has_permission?("view_bgs")
            return "You're not allowed to view GM secrets. See 'help secrets' for more information."
        end
        
        def handle
          ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
             template = BorderedDisplayTemplate.new model.gmsecrets, "#{model.name}'s GM Secrets"
             client.emit template.render                 
            end
        end
        
        
    end
  end
end