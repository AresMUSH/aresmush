module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end

      def on_command(client, cmd)
        args = cmd.crack_args!(/(?<target>[^\=]+)\=(?<desc>.+)/)

        valid = DescValidator.validate(args, client)
        return if !valid
                
        target = args[:target]
        desc = args[:desc]
        
        model = DescModelFinder.find(target, client)        
        return if model.nil?
        
        DescCommandHandler.execute(model, desc, client)        
      end
    end
    
    class DescModelFinder
      def self.find(target, client)
        Rooms.find_visible_object(target, client) 
      end
    end
    
    class DescValidator
      def self.validate(args, client)
        # TODO - return a value
        if args.nil?
          client.emit_failure(t('describe.invalid_desc_syntax'))
          return false
        end
        return true
      end
    end
    
    class DescCommandHandler
      def self.execute(model, desc, client)
        Describe.set_desc(model, desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
    end
  end
end
