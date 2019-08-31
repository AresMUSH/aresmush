module AresMUSH
  module Txt
      class TxtSendCmd
          include CommandHandler
# Possible commands... txt name=message; txt =message; txt name[/optional scene #]=<message>

          attr_accessor :names, :message, :scene_id, :scene, :txt, :txt_recipient

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
          # Is scene real and can you text to it?
          if self.scene_id
            scene = Scene[self.scene_id]
            can_txt_scene = Scenes.can_edit_scene?(enactor, scene)
            if !scene
              client.emit_failure t('txt.scene_not_found')
              return
            elsif scene.completed
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

          #Are recipients real and online?
          recipients = []
          self.names.each do |name|
            char = Character.named(name)

            if !char
              client.emit_failure t('txt.no_such_character')
              return
            elsif (!Login.is_online?(char) && !self.scene)
              client.emit_failure t('txt.target_offline_no_scene', :name => name )
              return
            else
              recipients.concat [char]
            end

            #Add recipient to scene
            if self.scene
              can_txt_scene = Scenes.can_edit_scene?(char, self.scene)
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
                  scene.participants.add char
                end

                if (!scene.watchers.include?(char))
                  scene.watchers.add char
                end

              end
            end
          end

          recipient_names = Txt.format_recipient_indicator(recipients)

          # If scene, add text to scene
          if self.scene
            scene_txt = t('txt.txt_to_scene_with_recipient',
            :txt => Txt.format_txt_indicator(enactor, recipient_names),
            :sender => enactor.name,
            # :recipients => recipient_names,
            :message => message,
            :scene_id => self.scene_id )

            Scenes.add_to_scene(self.scene, scene_txt, enactor)
            Rooms.emit_ooc_to_room self.scene.room, scene_txt
          end

          # If online, send emit to sender and recipients.

          self.txt = t('txt.txt_to_sender',
          :txt => Txt.format_txt_indicator(enactor, recipient_names),
          :sender => enactor.name,
          # :recipients => recipient_names,
          :message => message)
          #To recipients
          recipients.each do |char|
            if Login.is_online?(char)
              recipient = char

              if recipient.page_ignored.include?(enactor)
                client.emit_failure t('txt.cant_txt_ignored', :names => recipient.name)
                return
              elsif (recipient.page_do_not_disturb)
                client.emit_ooc t('page.recipient_do_not_disturb', :name => recipient.name)
                return
              end
              Txt.txt_recipient(enactor, recipient, recipient_names, self.txt, self.scene_id)
            end
          end
          #To sender
          if self.scene_id && (enactor.room.scene_id != self.scene_id)
            client.emit "#{self.txt} %xh%xx(Scene #{self.scene_id})"
          else
            client.emit self.txt
          end

          enactor.update(txt_last: list_arg(recipient_names))
          enactor.update(txt_scene: self.scene_id)

      end
      def log_command
          # Don't log texts
      end

    end
  end
end
