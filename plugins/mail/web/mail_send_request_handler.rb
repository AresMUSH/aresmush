module AresMUSH
  module Mail
    class MailSendRequestHandler
      def handle(request)
        enactor = request.enactor
        message = request.args[:message]
        subject = request.args[:subject]
        to_list = request.args[:to_list]
        thread_id = request.args[:thread]
       
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} sending mail to #{to_list}."
        
        thread = nil
        if (!thread_id.blank?)
          thread_msg = MailMessage[thread_id]
          if (thread_msg && thread_msg.thread)
            thread = thread_msg.thread
          end
        end
        
        if (subject.blank? || message.blank? || to_list.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        message = Website.format_input_for_mush(message)
        
        sent = Mail.send_mail(to_list, subject, message, nil, enactor, thread)
        if (!sent)
          return { error: t("mail.error_sending_mail") }
        end
        
        {
        }
      end
    end
  end
end