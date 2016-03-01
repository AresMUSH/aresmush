module AresMUSH
  module Mail
    class MailTagsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("tags")
      end
      
      def handle
        all_tags = []
        client.char.mail.each do |msg|
          all_tags = all_tags.concat(msg.tags)
        end
        
        client.emit BorderedDisplay.list all_tags.uniq.sort, t('mail.all_tags')
      end
    end
  end
end
