module AresMUSH
  module Login
    class TourCmd
      include CommandHandler

      def allow_without_login
        true
      end
            
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end
      
      def check_tour_permitted
        reason = Global.read_config('login', 'tour_not_allowed_message')
        return t('login.tour_restricted', :reason => reason) if !Login.allow_game_tour?
        return nil
      end
      
      def handle
        terms_of_service = Login.terms_of_service
        if (terms_of_service)
          template = BorderedDisplayTemplate.new terms_of_service
          client.emit template.render
        end

        name = Login.create_temp_char_name
        password = Login.generate_random_password
              
        char = Login.register_and_login_char(name, password, terms_of_service, client)
        Login.send_tour_welcome(char, password)
        
        client.emit_success t('login.temp_name', :name => name, :password => password)
      end
    end
  end
end
