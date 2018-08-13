module AresMUSH
  module Custom
    class SchoolsCmd
      include CommandHandler
      
      attr_accessor :target
      
        def parse_args
            self.target = Character.find_one_by_name(cmd.args)
        end
        
      
        def handle
            # client.emit line_with_text ("#{target.name}'s Schools")
            client.emit ("#{target.name}'s Schools")
            client.emit "Major School: #{target.major_school}"
              if target.minor_school != nil
                client.emit "Minor School: #{target.minor_school}"
              end
            # client.emit footer
            
            
        end
        
        
    end
  end
end