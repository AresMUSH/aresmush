module AresMUSH
  module Mail
    class MailTagsCmd
      include CommandHandler
      
      def handle
        all_tags = []
        enactor.mail.each do |msg|
          all_tags = all_tags.concat(msg.tags || [])
        end
        
        client.emit BorderedDisplay.list all_tags.uniq.sort, t('mail.all_tags')
      end
    end
  end
end
