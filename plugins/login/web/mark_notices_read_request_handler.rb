module AresMUSH
  module Login
    class LoginNoticesMarkReadRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        AresCentral.alts(enactor).each do |alt|
          alt.login_notices.find(is_unread: true).each { |n| n.update(is_unread: false)}
        end
        
        {}
      end
    end
  end
end