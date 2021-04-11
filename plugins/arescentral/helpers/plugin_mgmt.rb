module AresMUSH
  module AresCentral
    def self.register_plugin(name)
      return if !AresCentral.is_registered?
      
      Global.logger.info "Registering plugin import."
      
      connector = AresCentral::AresConnector.new
      response = connector.register_plugin({ "name" => name })
          
      if (response.is_success?)
        Global.logger.info "Plugin registered."
        return ""
      else
        raise "Response failed: #{response}"
      end
    end
  end
end