module AresMUSH
  module Login
    class LoginInfoRequestHandler
      def handle(request)      
        tos = Login.terms_of_service
        tos_md = tos ? Website.format_markdown_for_html(tos) : nil
        recaptcha = AresMUSH::Website::RecaptchaHelper.new
        turnstile = AresMUSH::Website::TurnstileHelper.new
          
        {
          recaptcha: recaptcha.is_enabled? ? recaptcha.site_key : nil,
          turnstile: turnstile.is_enabled? ? turnstile.site_key : nil,
          terms_of_service: tos_md,
          enable_registration: Global.read_config("login", "allow_web_registration")
        }
      end
    end
  end
end