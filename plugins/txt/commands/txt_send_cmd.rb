module AresMUSH
  module Txt
      class TxtSendCmd
          include CommandHandler
# Possible commands... txt name=message; txt =message; txt name[/optional scene #]=<message>

          attr_accessor :names, :message, :scene_id, :scene, :sender_txt

      def parse_args
          if (!cmd.args)
            self.names = []
          elsif (cmd.args.start_with?("="))
            self.names = enactor.txt_last
            self.scene_id = enactor.txt_scene
            self.message = cmd.args.after("=")

          elsif (cmd.args.include?("="))
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)

            # Catch the common mistake of last-paging someone a link.
            # p http://stuff.com/stuff=this.file
            if (args.arg1 && (args.arg1.include?("http://") || args.arg1.include?("https://")) )
              self.names = enactor.txt_last
              self.message = "#{args.arg1}=#{args.arg2}"

            elsif ( args.arg1.include?("/") )
              if args.arg1.rest("/").is_integer?
                self.scene_id = args.arg1.rest("/")
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              elsif args.arg1.rest("/").chr.casecmp?("s")
                self.scene_id = enactor.room.scene_id
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              end
            else
              self.names = list_arg(args.arg1)
              self.message = trim_arg(args.arg2)
            end

          else
            self.names = enactor.txt_last
            self.scene_id = enactor.txt_scene
            self.message = cmd.args
          end
      end

      def check_txt_target
          return t('txt.txt_target_missing') if !self.names || self.names.empty?
          return nil
      end

      def handle

        # Check if scene is real & if you can text to it.
        if self.scene_id
          Scenes.with_a_scene(self.scene_id, client) do |scene|
            if !scene
              client.emit_failure t('txt.scene_not_found')
              return
            end

            if (scene.completed)
              client.emit_failure t('txt.scene_not_running')
              return
            end

            if (!scene.room)
              raise "Trying to pose to a scene that doesn't have a room."
            end

            can_txt_scene = Scenes.can_join_scene?(enactor, scene)
            if (!can_txt_scene)
              client.emit_failure t('txt.scene_no_access')
              return
            end

            self.scene = scene
          end
          if !self.scene
            return
          end
        end

        # Check if the people are real. If so, and if scene, add to scene + emit to scene.

        recipients = []
        self.names.each do |name|
          char = Character.named(name)

          if !char
            client.emit_failure t('txt.no_such_character')
          else
            recipients.concat [char.name]
          end



          if self.scene
            can_txt_scene = Scenes.can_join_scene?(char, self.scene)
            if (!can_txt_scene)
              Scenes.add_to_scene(scene, t('txt.recipient_added_to_scene', :name => char.name ),
              enactor, nil, true )

              scene_room = self.scene.room
              Rooms.emit_ooc_to_room scene_room,t('txt.recipient_added_to_scene',
              :name => char.name )

              if (enactor.room == self.scene.room)
                nil
              else
                client.emit_success t('txt.recipient_added_to_scene',
                :name =>char.name )
              end

              if (!scene.participants.include?(char))
                scene.participants.add char
              end

              if (!scene.watchers.include?(char))
                scene.watchers.add char
              end
            end
          end
        end



        recipient_names = Txt.format_recipient_indicator(recipients)


        if self.scene
          scene_txt = t('txt.txt_to_scene_with_recipient',
          :txt => Txt.format_txt_indicator(enactor, recipient_names),
          :sender => enactor.name,
          # :recipients => recipient_names,
          :message => message,
          :scene_id => self.scene_id )

          Scenes.add_to_scene(self.scene, scene_txt, enactor)

          scene_room = self.scene.room
          Rooms.emit_ooc_to_room scene_room,scene_txt
        end

        self.sender_txt = t('txt.txt_to_sender',
        :txt => Txt.format_txt_indicator(enactor, recipient_names),
        :sender => enactor.name,
        # :recipients => recipient_names,
        :message => message)

        # Recipients must be online or a scene must be specified.
        self.names.each do |name|
          result = OnlineCharFinder.find(name)

          if !result.found? && !self.scene
            client.emit_failure t('txt.target_offline_no_scene', :name => name )
            return
          end
        end

        # If online, send emit.
        self.names.each do |name|
          result = OnlineCharFinder.find(name)

          if !result.found? && !self.scene
            client.emit_failure t('txt.target_offline_no_scene', :name => name )
            return
          elsif !result.found?
            nil
          else
            recipient = result.target.char
            recipient_client = result.target.client

            locked = recipient.page_ignored.include?(enactor)
            if locked
              client.emit_failure t('txt.cant_txt_ignored', :names => recipient.name)
              return
            end

            page_recipient(result.target.client, recipient, recipient_names, self.sender_txt)
          end
        end

        if self.scene_id && (enactor.room.scene_id == self.scene_id)
          nil
        elsif self.scene_id
          client.emit "#{self.sender_txt} %xh%xx(Scene #{self.scene_id})"
        else
          client.emit self.sender_txt
        end

        enactor.update(txt_last: recipients)
        enactor.update(txt_scene: self.scene_id)

        # Text monitoring. Emits txts to channel. Set to FALSE to turn off.
        # Edit "TxtMon" if using, but using a different channel name.
        if false
          channel = Channel.find_one_by_name("TxtMon")
          Channels.emit_to_channel(channel, self.sender_txt)
        end
      end

      def page_recipient(other_client, other_char, recipient_names, message)

        if (other_char.page_do_not_disturb)
          client.emit_ooc t('page.recipient_do_not_disturb', :name => other_char.name)

        elsif ( self.scene_id && ( other_char.room.scene_id == self.scene_id ) )
          nil
        elsif self.scene_id
          other_client.emit "#{message} %xh%xx(Scene #{self.scene_id})"
          Page.send_afk_message(client, other_client, other_char)
        elsif !self.scene_id
          other_client.emit message
          Page.send_afk_message(client, other_client, other_char)
        end

        txt_received = "#{recipient_names}" + " #{enactor.name}"
        txt_received.slice! "#{other_char.name}"

        other_char.update(txt_received: (txt_received.squish))
        other_char.update(txt_received_scene: self.scene_id)
      end

      def log_command
          # TBD. For now, it'll send message to monitoring com channel. See handle.
      end
    end
  end
end
