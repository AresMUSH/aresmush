module AresMUSH
  module Describe

    def self.interface(plugin_manager)
      plugin_manager.interface("Describe::DescFunctions")
    end
    
    
    
    class DescFunctions 
      include AresMUSH::Plugin
      
      def after_initialize
        @desc_factory = DescFactory.new(container)
      end
      
      def get_desc(model)
        renderer = @desc_factory.build(model)
        renderer.render
      end
      
    end
    
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model["name"]} #{desc}")
      
      model["description"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
    end
    
  end
end
