module AresMUSH

  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end

      def crack!
        @cmd.crack!(/(?<target>[^\=]+)\=(?<desc>.+)/)
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !@cmd.logged_in?
        return t('describe.invalid_desc_syntax') if (args.nil? || args.target.nil? || args.desc.nil?)
        return nil
      end
      
      def handle
        # TODO - this should be in the validate method but needs refactoring of visible target finder
        model = VisibleTargetFinder.find(args.target, client) 
        return if model.nil?

        Describe.set_desc(model, args.desc)
        client.emit_success(t('describe.desc_set', :name => model["name"]))
      end
        
    end
  end
end
