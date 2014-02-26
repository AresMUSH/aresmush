module AresMUSH

  module Describe
    class GlanceCmd
      include AresMUSH::Plugin
      
      attr_accessor :desc

      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("glance")
      end

      def crack!
        cmd.crack!(/(?<desc>.+)/)
        self.desc = cmd.args.desc
      end
      
      def validate_syntax
        return t('describe.invalid_glance_syntax') if desc.nil?
        return nil
      end
      
      def handle
        client.char.glance = desc
        client.char.save!
        client.emit_success(t('describe.glance_set'))
      end
        
    end
  end
end
