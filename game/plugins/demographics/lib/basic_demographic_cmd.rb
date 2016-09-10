module AresMUSH
  module Demographics

    module BasicDemographicCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :value, :property

      def initialize
        self.required_args = ['value']
        self.help_topic = 'demographics'
        super
      end
            
      def crack!
        self.value = trim_input(cmd.args)
        self.property = cmd.root.downcase
      end
      
      def handle
        client.char.send("#{self.property}=", self.value)
        client.char.save
        client.emit_success t('demographics.property_set', :property => self.property, :value => self.value)
      end
    end
    
    class HeightCmd
      include BasicDemographicCmd
      
      def check_chargen_locked
        Chargen::Interface.check_chargen_locked(client.char)
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("height")
      end
    end
    
    class PhysiqueCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("physique")
      end
    end
    
    class EyesCmd
      include BasicDemographicCmd

      def check_chargen_locked
        Chargen::Interface.check_chargen_locked(client.char)
      end

      def want_command?(client, cmd)
        cmd.root_is?("eyes")
      end
    end
    
    class HairCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("hair")
      end
    end
    
    class SkinCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("skin")
      end
    end
    
    class FullnameCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("fullname")
      end
    end
    
    class CallsignCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("callsign")
      end
    end
    
    class GenderCmd
      include BasicDemographicCmd
      
      def check_chargen_locked
        Chargen::Interface.check_chargen_locked(client.char)
      end
      
      def crack!
        self.value = titleize_input(cmd.args)
        self.property = cmd.root.downcase
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("gender")
      end
      
      def check_gender
        genders = [ "Male", "Female", "Other" ]
        return nil if genders.include?(self.value)
        return t('demographics.invalid_gender')
      end
    end
    
  end
end