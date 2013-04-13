module AresMUSH
  module Describe

    def self.interface(plugin_manager)
      plugin_manager.interface("Describe::DescFunctions")
    end
    
    
    
    class DescFunctions 
      include AresMUSH::Plugin
      
      def get_desc(model)
        renderer = DescFactory.build(model, container)
        desc = renderer.render
        Formatter.perform_subs(desc)
      end
      
    end
    
    def self.set_desc(client, model, desc)  
      logger.debug("Setting desc: #{client} #{model["name"]} #{desc}")
      
      model["desc"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
      client.emit_success(t('describe.desc_set', :name => model["name"]))
    end
    
  end
end
