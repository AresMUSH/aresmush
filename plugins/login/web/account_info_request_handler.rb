module AresMUSH
  module Login
    class AccountInfoRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        timezones = OOCTime.timezone_aliases.keys.concat OOCTime.timezone_names.sort
        
        {
          handle: enactor.handle ? enactor.handle.name : nil,
          email: enactor.login_email,
          name: enactor.name,
          timezone: enactor.ooctime_timezone,
          timezones: timezones
        }
      end
    end
  end
end