module AresMUSH
    module Txt
        class AddTxtRequestHandler

            def handle(request)
                scene_id = request.args[:scene_id]
                scene = Scene[request.args[:scene_id]]
                enactor = request.enactor
                pose = request.args[:pose]

                # if !enactor.txt_last_scene
                #     enactor.update(txt_last_scene: [])
                # end

                if (!scene)
                    return { error: t('webportal.not_found') }
                end

                error = Website.check_login(request)
                return error if error

                if (!Scenes.can_read_scene?(enactor, scene))
                    return { error: t('scenes.access_not_allowed') }
                end

                if (scene.completed)
                    return { error: t('scenes.scene_already_completed') }
                end

                if (!scene.room)
                    raise "Trying to pose to a scene that doesn't have a room."
                end

                pose = Website.format_input_for_mush(pose)

                if pose.start_with?("=")
                    message = pose.after("=")
                    recipients = scene.participants
                elsif pose.include?("=")
                    if (!pose.rest("=").blank? && (pose.first("=").include?("http://") || pose.first("=").include?("https://") ) )
                        recipients = scene.participants
                        message = pose
                    else
                        names = pose.first("=") ? pose.first("=").split(" ") : nil
                        if names[0].titlecase == enactor.name
                          return { error: t('txt.dont_txt_self') }
                        end
                        recipients = [enactor]
                        names.each do |name|
                          char = Character.named(name)
                          if !char
                            return { error: t('txt.no_such_character') }
                          else
                            recipients.concat [char]
                          end
                        end
                        message = pose.rest("=")
                    end
                else
                  recipients = scene.participants.to_a
                  message = pose
                end

                recipient_names = Txt.format_recipient_names(recipients)
                recipient_display_names = Txt.format_recipient_display_names(recipients, enactor)
                sender_display_name = Txt.format_sender_display_name(enactor)
                scene_room = scene.room
                use_only_nick = Global.read_config("txt", "use_only_nick")
                if use_only_nick
                  scene_id_display = "#{scene_id} - #{enactor.name}"
                else
                  scene_id_display = scene_id
                end

                recipients.each do |char|
                  can_txt_scene = Scenes.can_read_scene?(char, scene)
                  #If they aren't in the scene currently, add them
                  if (!can_txt_scene)
                    Scenes.add_to_scene(scene, t('txt.recipient_added_to_scene',
                    :name => char.name ),
                    enactor, nil, true )

                    Rooms.emit_ooc_to_room scene_room,t('txt.recipient_added_to_scene',
                    :name => char.name )

                    if (!scene.participants.include?(char))
                      scene.participants.add char
                    end

                    if (!scene.watchers.include?(char))
                      scene.watchers.add char
                    end
                  end

                  txt_received = "#{recipient_names}"
                  txt_received.slice! "#{char.name}"
                  char.update(txt_received: (txt_received.squish))
                  char.update(txt_received_scene: scene_id)

                  #Emit to online players


                  if Login.is_online?(char)
                    recipient_txt = t('txt.txt_with_scene_id',
                    :txt => Txt.format_txt_indicator(enactor, recipient_display_names),
                    :sender => sender_display_name,
                    :message => message,
                    :scene_id => scene_id_display)

                    if (char.page_do_not_disturb)
                      nil
                    elsif char.room.scene_id != scene_id
                      client = Login.find_client(char)
                      client.emit recipient_txt
                    else
                      nil
                    end
                  end
                end

                scene_txt = t('txt.txt_no_scene_id',
                :txt => Txt.format_txt_indicator(enactor, recipient_display_names),
                :sender => sender_display_name,
                :message => message )
                Scenes.add_to_scene(scene, scene_txt, enactor)

                room_txt = t('txt.txt_with_scene_id',
                :txt => Txt.format_txt_indicator(enactor, recipient_display_names),
                :sender => sender_display_name,
                :message => message,
                :scene_id => scene_id_display)

                Rooms.emit_ooc_to_room scene_room,room_txt

                {
                }
            end
        end
    end
end
