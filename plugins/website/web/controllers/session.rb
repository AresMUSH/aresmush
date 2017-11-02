module AresMUSH
  class WebApp    
    attr_accessor :user
    
    before do
      user_id = session[:user_id]
      @user = user_id ? Character[user_id] : nil
      
      if (@user && (@user.login_api_token != session[:login_token]))
        flash[:error] = "Please log in again."
        session.clear
        redirect to('/')
      end
      
      if (@user && @user.login_api_token_expiry < Time.now)
        flash[:error] = "Your session has expired.  Please log in again."
        session.clear
        redirect to('/')
      end
      
      @recaptcha = AresMUSH::Website::RecaptchaHelper.new
    end
    
    helpers do
      def is_user?
        @user != nil
      end
      
      def enable_registration
        return Global.read_config("login", "allow_web_registration")
      end
      
      def is_admin?
        @user != nil && @user.is_admin?
      end
      
      def is_approved?
        @user != nil && (@user.is_approved? || @user.is_admin?)
      end
      
      def is_not_user?
        @user == nil
      end
    end
    
  end
end
