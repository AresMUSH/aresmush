module AresMUSH
  module Describe
    class Look
      include AresMUSH::Plugin
      

      def want_command?(cmd)
        cmd.root_is?("look")
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !@cmd.logged_in?
        return nil
      end
      
      def crack!
        cmd.crack!(/(?<target>.+)/)
      end
      
      def handle

        # Default to 'here' if no args are specified.
        target = args.target || t('object.here')

        find_result = VisibleTargetFinder.find(target, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end

        model = find_result.target
        desc = Describe.get_desc(model)
        client.emit(desc)
      end      
    end
  end
end
