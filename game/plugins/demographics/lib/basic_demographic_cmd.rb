module AresMUSH
  module Demographics

    module BasicDemographicCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :value, :property

      def crack!
        self.value = trim_input(cmd.args)
        self.property = cmd.root.downcase
      end
      
      def required_args
        {
          args: [ self.value ],
          help: 'demographics'
        }
      end
         
      def handle
        demographics = enactor.get_or_create_demographics
        demographics.send("#{self.property}=", self.value)
        demographics.save
        client.emit_success t('demographics.property_set', :property => self.property, :value => self.value)
      end
    end
    
    class HeightCmd
      include BasicDemographicCmd
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end      
    end
    
    class PhysiqueCmd
      include BasicDemographicCmd      
    end
    
    class EyesCmd
      include BasicDemographicCmd

      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
    end
    
    class HairCmd
      include BasicDemographicCmd      
    end
    
    class SkinCmd
      include BasicDemographicCmd      
    end
    
    class FullnameCmd
      include BasicDemographicCmd
      
    end
    
    class CallsignCmd
      include BasicDemographicCmd      
    end
    
    class GenderCmd
      include BasicDemographicCmd
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def crack!
        self.value = titleize_input(cmd.args)
        self.property = cmd.root.downcase
      end
      
      def check_gender
        genders = [ "Male", "Female", "Other" ]
        return nil if genders.include?(self.value)
        return t('demographics.invalid_gender')
      end
    end
    
  end
end