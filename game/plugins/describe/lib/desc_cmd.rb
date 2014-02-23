module AresMUSH

  module Describe
    class DescCmd
      include AresMUSH::Plugin
      
      attr_accessor :target, :desc

      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("desc")
      end

      def crack!
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
        self.target = cmd.args.target
        self.desc = cmd.args.desc
      end
      
      def validate_syntax
        return t('describe.invalid_desc_syntax') if (target.nil? || desc.nil?)
        return nil
      end
      
      def handle
        find_result = VisibleTargetFinder.find(target, client) 
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        model = find_result.target
        Describe.set_desc(model, desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
        
    end
  end
end
