module AresMUSH
  module Mail
    class MailTagsCmd
      include CommandHandler
      
      def handle
        all_tags = []
        Mail.all_tags(enactor)
        
        template = BorderedListTemplate.new all_tags.uniq.sort, t('mail.all_tags')
        client.emit template.render
      end
    end
  end
end
