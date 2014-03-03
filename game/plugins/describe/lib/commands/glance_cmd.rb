module AresMUSH

  module Describe
    class GlanceCmd
      include AresMUSH::Plugin
      
      attr_accessor :desc

      # Validators
      must_be_logged_in
      no_switches
            
      def want_command?(client, cmd)
        cmd.root_is?("glance")
      end

      def crack!
        self.desc = cmd.args
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
