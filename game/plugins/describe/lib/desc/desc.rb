module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("desc")
      end

      def on_command(client, cmd)
        args = crack(cmd)
        
        valid = validate(args, client)
        return if !valid

        model = VisibleTargetFinder.find(args.target, client) 
        return if model.nil?

        handle(model, args.desc, client)        
      end
      
      def crack(cmd)
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
      end
      
      def validate(args, client)
        if (args.nil? || args.target.nil? || args.desc.nil?)
          client.emit_failure(t('describe.invalid_desc_syntax'))
          return false
        end
        return true
      end
      
      def handle(model, desc, client)
        Describe.set_desc(model, desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
        
    end
  end
end
