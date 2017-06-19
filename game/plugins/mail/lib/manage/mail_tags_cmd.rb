module AresMUSH
  module Mail
    class MailTagsCmd
      include CommandHandler
      
      def handle
        all_tags = []
        enactor.mail.each do |msg|
          all_tags = all_tags.concat(msg.tags || [])
        end
        
        template = BorderedListTemplate.new all_tags.uniq.sort, t('mail.all_tags')
        client.emit template.render
      end
    end
  end
end
