module AresMUSH
  module Channels
    class FlagChatRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args['id']
        flagged = (request.args['flagged'] || "").to_bool
        
        error = Website.check_login(request)
        return error if error

        request.log_request
        
        msg = ChannelMessage[id]
        if (!msg)
          return { error: t('webportal.not_found') }
        end
        
        msg.update(flagged: flagged)
        
        if (flagged)
          channel = msg.channel        
          body = t('channels.channel_flagged_body', :name => channel.name, :reporter => enactor.name)
          body << "%R-------%R"
          body << "[#{OOCTime.local_long_timestr(enactor, msg.created_at)}] #{Channels.display_name(nil, channel)} #{msg.message}"

          Jobs.create_job(Jobs.trouble_category, t('channels.channel_flagged_title'), body, Game.master.system_character)
        end               
        
        {
        }
      end
    end
  end
end


