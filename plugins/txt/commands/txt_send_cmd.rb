module AresMUSH
  module Txt
      class TxtSendCmd
          include CommandHandler
# Possible commands... txt name=message; txt =message; txt name[/optional scene #]=<message>

          attr_accessor :names, :message, :scene_id, :scene, :txt, :txt_recipient, :use_only_nick

        def parse_args
          if (!cmd.args)
            return t('dispatcher.invalid_syntax', :cmd => 'txt')
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
            #Text a specific scene
            elsif ( args.arg1.include?("/") )
              if args.arg1.rest("/").is_integer?
                self.scene_id = args.arg1.rest("/")
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              #Text the scene you are physically in
              elsif args.arg1.rest("/").chr.casecmp?("s")
                self.scene_id = enactor.room.scene_id
                self.names = list_arg(args.arg1.first("/"))
                self.message = trim_arg(args.arg2)
              end
            else
              #Text someone without a scene
              self.names = list_arg(args.arg1)
              self.message = trim_arg(args.arg2)
            end

          else
            #Text your last recipient and scene
            self.names = enactor.txt_last || []
            self.scene_id = enactor.txt_scene
            self.message = cmd.args
          end
        end

        def check_errors
          return t('dispatcher.not_allowed') if !enactor.is_approved?
          return t('txt.txt_target_missing') if !self.names || self.names.empty?
          return nil
        end

        def handle
          # Is scene real and can you text to it?
          if self.scene_id
            scene = Scene[self.scene_id]
            if !scene
              client.emit_failure t('txt.scene_not_found')
            end
            can_txt_scene = Scenes.can_read_scene?(enactor, scene)
            if scene.completed
              client.emit_failure t('txt.scene_not_running')
              return
            elsif !scene.room
              raise "Trying to pose to a scene that doesn't have a room."
            elsif !can_txt_scene
              client.emit_failure t('txt.scene_no_access')
              return
            end
            self.scene = scene
          end

          #Are recipients real, online, and in the scene?
          recipients = []
          self.names.each do |name|
            char = Character.named(name)
            if !char
              client.emit_failure t('txt.no_such_character')
              return
            elsif (!Login.is_online?(char) && !self.scene)
              client.emit_failure t('txt.target_offline_no_scene', :name => name.titlecase )
              return
            else
              recipients.concat [char]
            end

            #Add recipient to scene if they are not already a participant
            if self.scene
              can_txt_scene = Scenes.can_read_scene?(char, self.scene)
              if (!can_txt_scene)
                Scenes.add_to_scene(scene, t('txt.recipient_added_to_scene', :name => char.name ),
                enactor, nil, true )
                Rooms.emit_ooc_to_room self.scene.room, t('txt.recipient_added_to_scene',
                :name => char.name )

                if (enactor.room != self.scene.room)
                  client.emit_success t('txt.recipient_added_to_scene',
                  :name =>char.name )
                end

                if (!scene.participants.include?(char))
                  Scenes.add_participant(scene, char, enactor)
                end

              end
            end
          end

          recipient_display_names = Txt.format_recipient_display_names(recipients, enactor)
          recipient_names = Txt.format_recipient_names(recipients)
          sender_display_name = Txt.format_sender_display_name(enactor)

          self.use_only_nick = Global.read_config("txt", "use_only_nick")
          # If scene, add text to scene
          if self.scene
            if self.use_only_nick
              scene_id_display = "#{self.scene_id} - #{enactor.name}"
            else
              scene_id_display = self.scene_id
            end

            scene_txt = t('txt.txt_no_scene_id', :txt => Txt.format_txt_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message)

            self.txt = t('txt.txt_with_scene_id', :txt => Txt.format_txt_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message, :scene_id => scene_id_display )

            Scenes.add_to_scene(self.scene, scene_txt, enactor)
            Rooms.emit_ooc_to_room self.scene.room, scene_txt
          else
            if self.use_only_nick
              self.txt = t('txt.txt_no_scene_id_nick', :txt => Txt.format_txt_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message, :sender_char => enactor.name )
            else
              self.txt = t('txt.txt_no_scene_id', :txt => Txt.format_txt_indicator(enactor, recipient_display_names), :sender => sender_display_name, :message => message)
            end

          end

        # If online, send emit to sender and recipients if they aren't in the scene's room.
          #To recipients
          recipients.each do |char|
            if (Login.is_online?(char)) && (!self.scene || char.room != self.scene.room)
              if char.page_ignored.include?(enactor)
                client.emit_failure t('txt.cant_txt_ignored', :names => char.name)
                return
              elsif (char.page_do_not_disturb)
                client.emit_ooc t('page.recipient_do_not_disturb', :name => char.name)
                return
              end
              Txt.txt_recipient(enactor, char, recipient_display_names, self.txt, self.scene_id)
            end
            txt_received = "#{recipient_names}" + " #{enactor.name}"
            txt_received.slice! "#{char.name}"
            char.update(txt_received: (txt_received.squish))
            char.update(txt_received_scene: self.scene_id)
          end

          #To sender
          if (!self.scene || enactor_room != self.scene.room)
            client.emit self.txt
          end


          enactor.update(txt_last: list_arg(recipient_names))
          enactor.update(txt_scene: self.scene_id)
          Scenes.handle_word_count_achievements(enactor, message)
      end

      def log_command
        # Don't log texts
      end
    end
  end
end
