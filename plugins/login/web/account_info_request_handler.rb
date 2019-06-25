module AresMUSH
  module Login
    class AccountInfoRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        {
          handle: enactor.handle ? enactor.handle.name : nil
        }
      end
    end
  end
end