module AresMUSH
  module ACL_CharModel
    class ACLCharModelCmd
      include CommandHandler
      
      attr_accessor :search, :mode, :name
      
      def parse_args
        #self.search = titlecase_arg(cmd.args)
        #self.mode = downcase_arg(cmd.switch)
		self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
      
      def allow_without_login
        false
      end
      
      def handle
         ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          #template = ACL_CharModelTemplate.new model
          #client.emit template.render
		  client.emit "Here"
		  client.emit (model.inspect)
        end		
      end      
    end
  end
end
