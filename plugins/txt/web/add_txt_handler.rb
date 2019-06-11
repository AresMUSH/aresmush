module AresMUSH
    module Txt
        class AddTxtRequestHandler

            attr_accessor :scene_txt

            def handle(request)
                scene_id = request.args[:scene_id]
                scene = Scene[request.args[:scene_id]]
                enactor = request.enactor
                pose = request.args[:pose]

                if !enactor.txt_last_scene
                    enactor.update(txt_last_scene: [])
                end

                if (!scene)
                    return { error: t('webportal.not_found') }
                end

                error = Website.check_login(request)
                return error if error

                if (!Scenes.can_join_scene?(enactor, scene))
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
                    names = enactor.txt_last_scene
                    names_raw = Txt.format_recipient_indicator(names)
                    message = pose.after("=")
                elsif pose.include?("=")
                    if (!pose.rest("=").blank? && (pose.first("=").include?("http://") || pose.first("=").include?("https://") ) )
                        names = enactor.txt_last_scene
                        message = pose
                    else
                        names_raw = pose.first("=")
                        names = pose.first("=") ? pose.first("=").split(" ") : nil
                        message = pose.rest("=")
                    end
                else
                    names = enactor.txt_last_scene
                    names_raw = Txt.format_recipient_indicator(names)
                    message = pose
                end

                if ( !names || names.empty? )
                    { error: t('txt.txt_target_missing') }
                end

                names_raw = InputFormatter.titlecase_arg(names_raw)
                #Making 'Names Raw' take actual character names instead of aliases.
                names_array = names_raw.split(/ /)
                names_raw = []
                names_array.each do |name|
                  char = Character.named(name)
                  if !char
                    return { error: t('txt.no_such_character') }
                  else
                    names_raw.concat [char.name]
                  end
                end
                names_raw = names_raw.join(" ")



                scene_room = scene.room

                if !names.empty?
                  recipients = []
                    names.each do |name|
                        char = Character.named(name)

                        if !char
                          return { error: t('txt.no_such_character') }
                        else
                          recipients.concat [char.name]
                        end

                        can_txt_scene = Scenes.can_join_scene?(char, scene)
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
                    end

                    names_plus = recipients << enactor.name

                    names_plus.each do |name|
                        result = OnlineCharFinder.find(name)

                        if (!result.found?)
                            nil
                        else
                            recipient = result.target.char

                            recipient_txt = t('txt.txt_to_recipient_with_scene',
                            :txt => Txt.format_txt_indicator(enactor, names_raw),
                            :sender => enactor.name,
                            # :recipients => names_raw,
                            :message => message,
                            :scene_id => scene_id)

                            if (recipient.page_do_not_disturb)
                              nil
                            elsif ( scene_id && ( recipient.room.scene_id != scene_id ) )
                                result.target.client.emit recipient_txt
                            else
                              nil
                            end

                            txt_received = "#{names_raw}" + " #{enactor.name}"
                            txt_received.slice! "#{recipient.name}"

                            recipient.update(txt_received: (txt_received.squish))
                            recipient.update(txt_received_scene: scene_id)
                        end
                    end
                end

                if names.empty?
                    self.scene_txt = t('txt.txt_to_scene_no_recipient',
                    :txt => Txt.format_txt_indicator(enactor, names_raw),
                    :sender => enactor.name,
                    :message => message )
                else
                    self.scene_txt = t('txt.txt_to_scene_with_recipient',
                    :txt => Txt.format_txt_indicator(enactor, names_raw),
                    :sender => enactor.name,
                    # :recipients => names_raw,
                    :message => message )
                end

                room_txt = t('txt.txt_to_recipient_with_scene',
                :txt => Txt.format_txt_indicator(enactor, names_raw),
                :sender => enactor.name,
                :message => message,
                :scene_id => scene_id)

                Rooms.emit_ooc_to_room scene_room,room_txt

                recipients.delete(enactor.name)

                enactor.update(txt_last_scene: recipients)

                Scenes.add_to_scene(scene, self.scene_txt, enactor)

                {
                }
            end
        end
    end
end
