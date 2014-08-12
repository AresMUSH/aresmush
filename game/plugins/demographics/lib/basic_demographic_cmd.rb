module AresMUSH
  module Demographics

    module BasicDemographicCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
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
      
      def want_command?(client, cmd)
        cmd.root_is?("height")
      end
    end
    
    class BuildCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("build")
      end
    end
    
    class EyesCmd
      include BasicDemographicCmd
      
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
    
    class FullnameCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("fullname")
      end
    end
    
    class FullnameCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("fullname")
      end
    end
    
    class GenderCmd
      include BasicDemographicCmd
      
      def want_command?(client, cmd)
        cmd.root_is?("gender")
      end
      
      def check_gender
        return nil if self.value == "male"
        return nil if self.value == "female"
        return nil if self.value == "other"
        return t('demographics.invalid_gender')
      end
    end
    
  end
end