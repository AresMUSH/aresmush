module AresMUSH
  module Jobs
    class JobReplyRequestHandler
      def handle(request)
        enactor = request.enactor
        job = Job[request.args[:id]]
        reply = request.args[:reply]
        admin_only = request.args[:admin_only].to_bool
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!job)
          return { error: t('webportal.not_found') }
        end
        
        reply = WebHelpers.format_input_for_mush(reply)
        Jobs.comment(job, enactor, reply, admin_only)
        
        {
        }
      end
    end
  end
end