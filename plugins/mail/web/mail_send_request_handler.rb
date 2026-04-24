module AresMUSH
  module Mail
    class MailSendRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args['message']
        subject = request.args['subject']
        to_list = request.args['to_list']
        sender = Character.named(request.args['sender']) || enactor
       
        error = Website.check_login(request)
        return error if error
        
        if (!AresCentral.is_alt?(sender, enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        Global.logger.info "#{sender.name} sending mail to #{to_list} (by #{enactor.name})."
        
        if (subject.blank? || message.blank? || to_list.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "subject, message, to list") }
        end
        
        message = Website.format_input_for_mush(message)
        
        sent = Mail.send_mail(to_list, subject, message, nil, sender)
        if (!sent)
          return { error: t("mail.error_sending_mail") }
        end
        
        {
        }
      end
    end
  end
end