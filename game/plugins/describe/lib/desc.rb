module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(client, cmd)
        cmd.root_is?("desc")
      end

      def crack!
        @cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !@cmd.logged_in?
        return t('describe.invalid_desc_syntax') if (args.target.nil? || args.desc.nil?)
        return nil
      end
      
      def handle
        find_result = VisibleTargetFinder.find(args.target, client) 
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        model = find_result.target
        Describe.set_desc(model, args.desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
        
    end
  end
end
