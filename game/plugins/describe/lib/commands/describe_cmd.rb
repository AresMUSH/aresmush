module AresMUSH

  module Describe
    class DescCmd
      include AresMUSH::Plugin
      
      attr_accessor :target, :desc

      # Validators
      must_be_logged_in
      no_switches
      argument_must_be_present "target", "desc"
      argument_must_be_present "desc", "desc"
      
      # TODO - Permissions
      
      def want_command?(client, cmd)
        cmd.root_is?("describe") || cmd.root_is?("shortdesc")
      end

      def crack!
        cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
        self.target = trim_input(cmd.args.target)
        self.desc = cmd.args.desc
      end
      
      def handle
        find_result = VisibleTargetFinder.find(target, client) 
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        model = find_result.target
        if (cmd.root_is?("shortdesc"))
          model.shortdesc = desc
        else
          Describe.set_desc(model, desc)
        end
        client.emit_success(t('describe.desc_set', :name => model.name))
      end
        
    end
  end
end
