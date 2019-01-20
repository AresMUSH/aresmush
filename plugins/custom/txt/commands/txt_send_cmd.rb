module AresMUSH
    module Txt 
        class TxtSendCmd
            include CommandHandler
# Possible commands... txt name=message; txt =message; txt name[/optional scene #]=<message>
            
            attr_accessor :names, :message, :scene_id

        def parse_args
            if (!cmd.args)
              self.names = []
            elsif (cmd.args.start_with?("="))
              self.names = enactor.txt_last
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
              self.message = cmd.args
            end
        end

        def check_txt_target
            return t('txt.txt_target_missing') if !self.names || self.names.empty?
            return nil
        end

      
        def handle

          OnlineCharFinder.with_online_chars(self.names, client) do |results|
            recipients = results.map { |result| result.char }

            name = enactor.name
            message = self.message
            recipient_names = recipients.map { |r| r.name }
  
            sender_txt = t('txt.txt_to_sender', 
            :txt => Txt.format_txt_indicator(enactor),
            :sender => enactor.name, 
            :recipients => Txt.format_recipient_indicator(recipient_names), 
            :message => message)

            scene_txt = t('txt.txt_to_scene', 
            :txt => Txt.format_txt_indicator(enactor),
            :sender => enactor.name, 
            :recipients => Txt.format_recipient_indicator(recipient_names), 
            :message => message )
            
            locked = recipients.select { |c| c.page_ignored.include?(enactor) }
            if (locked.any?)
              locked_names = locked.map { |c| c.name }
              client.emit_failure t('txt.cant_txt_ignored', :names => locked_names.join(" "))
              return
            end

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
  
                can_txt_scene = Scenes.can_access_scene?(enactor, scene)        
                if (!can_txt_scene)
                  client.emit_failure t('txt.scene_no_access')
                  return
                end
  
                Scenes.add_to_scene(scene, scene_txt)

                if enactor.room.scene_id != self.scene_id
                  client.emit "#{sender_txt} %xh%xx(Scene #{self.scene_id})"
                end

                if not Scene[self.scene_id].room.blank?
                  scene_room = Scene[self.scene_id].room
                  Rooms.emit_ooc_to_room scene_room,sender_txt
                end

                results.each do |r|
                  page_recipient(r.client, r.char, recipient_names, message)
                end   

              end
            else
              client.emit sender_txt

              results.each do |r|
                page_recipient(r.client, r.char, recipient_names, message)
              end   

            end

            enactor.update(txt_last: self.names)

            # Text monitoring. Emits txts to channel. Set to FALSE to turn off.
            # Edit "TxtMon" if using, but using a different channel name.
            if false
              channel = Channel.find_one_by_name("TxtMon")
              Channels.emit_to_channel(channel, sender_txt)
            end

          end
        end

        def page_recipient(other_client, other_char, recipient_names, message)

          recipient_txt = t('txt.txt_to_recipient', 
          :txt => Txt.format_txt_indicator(other_char),
          :sender => enactor.name, 
          :recipients => Txt.format_recipient_indicator(recipient_names), 
          :message => message)

            if (other_char.page_do_not_disturb)
              client.emit_ooc t('page.recipient_do_not_disturb', :name => other_char.name)

            elsif ( self.scene_id && ( other_char.room.scene_id != self.scene_id ) )
              other_client.emit "#{recipient_txt} %xh%xx(Scene #{self.scene_id})"
              Page.send_afk_message(client, other_client, other_char)

            elsif !self.scene_id

              other_client.emit recipient_txt
              Page.send_afk_message(client, other_client, other_char)

            end
        end

        def log_command
            # TBD. For now, it'll send message to monitoring com channel. See handle.
        end

        end
    end
end