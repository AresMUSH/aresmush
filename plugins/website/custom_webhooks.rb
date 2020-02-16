module AresMUSH
  module Website
    def self.custom_webhooks(request)
      #if (request.args['cmd'] == 'yourcommand')
      #  ...do something with the command...
      #  return {}
      #end
      
      # Always return {}.
      return {}
    end
  end
end