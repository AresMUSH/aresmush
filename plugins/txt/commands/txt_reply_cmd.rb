module AresMUSH
  module Txt
    class TxtReplyCmd
      include CommandHandler

      attr_accessor :names, :names_raw, :message, :scene_id

      def parse_args
        self.message = cmd.args
      end

      def check_received_txts
        unless enactor.txt_received
          client.emit_failure t('txt.no_one_to_reply_to')
          return
        end
      end

      def handle
        if !self.message
          #Tell what the last text recieved was
          if enactor.txt_received_scene
            client.emit_success t('txt.reply_scene', :names => enactor.txt_received, :scene => enactor.txt_received_scene)
          else
            client.emit_success t('txt.reply', :names => enactor.txt_received )
          end
        elsif enactor.txt_received_scene
          Global.dispatcher.queue_command(client, Command.new("txt #{enactor.txt_received}/#{enactor.txt_received_scene}=#{self.message}"))
        else
          Global.dispatcher.queue_command(client, Command.new("txt #{enactor.txt_received}=#{self.message}"))
        end
      end

      def log_command
          # Don't log texts
      end

    end
  end
end
