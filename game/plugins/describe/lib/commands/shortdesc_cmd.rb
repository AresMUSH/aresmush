module AresMUSH

  module Describe
    class ShortdescCmd
      include AresMUSH::Plugin
      
      attr_accessor :desc

      # Validators
      must_be_logged_in
      no_switches
            
      def want_command?(client, cmd)
        cmd.root_is?("shortdesc")
      end

      def crack!
        self.desc = cmd.args
      end
      
      def validate_syntax
        return t('describe.invalid_shortdesc_syntax') if desc.nil?
        return nil
      end
      
      def handle
        client.char.shortdesc = desc
        client.char.save!
        client.emit_success(t('describe.shortdesc_set'))
      end
        
    end
  end
end
