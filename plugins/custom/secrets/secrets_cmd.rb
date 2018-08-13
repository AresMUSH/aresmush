module AresMUSH
  module Custom
    class SecretsCmd
      include CommandHandler
      
      attr_accessor :name
      
        def parse_args
            self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
        end
        
        def check_can_view
            return nil if self.name == enactor_name
            return nil if enactor.has_permission?("view_bgs")
            return "You're not allowed to view other peoples' secrets."
        end
        
        def handle
            ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
                template = BorderedDisplayTemplate.new model.secrets, "#{model.name}'s Secrets"
                client.emit template.render     
            end
            if enactor.has_permission?("view_bgs")
              ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
                  template = BorderedDisplayTemplate.new model.gmsecrets, "#{model.name}'s GM Secrets"
                  client.emit template.render                 
             end
            end
            
        end
        
        
    end
  end
end