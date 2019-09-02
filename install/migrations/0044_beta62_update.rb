module AresMUSH  

  module Migrations
    class MigrationBeta62Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "FS3 incapable rename."
        config = DatabaseMigrator.read_config_file("fs3skills_chargen.yml")
        if (!config['fs3skills']['allow_unskilled_action_skills'] )
          config['fs3skills']['allow_incapable_action_skills'] = config['fs3skills']['allow_unskilled_action_skills']
          config['fs3skills'].delete 'allow_unskilled_action_skills'
          config = DatabaseMigrator.write_config_file("fs3skills_chargen.yml", config)
        end
                               
        Global.logger.debug "Achievements."
        config = DatabaseMigrator.read_config_file("achievements.yml")
        if (!config['achievements']['achievements'])
          config['achievements']['achievements'] = config['achievements']['custom_achievements']
          config['achievements'].delete 'custom_achievements'
        end
        config = DatabaseMigrator.write_config_file("achievements.yml", config)

        set_achievements("arescentral.yml", "arescentral", {
          'handle_linked' => { 'type' => 'community', 'message' => "Linked a character to a player handle." }
        })

        set_achievements("chargen.yml", "chargen", {
          'created_character' => { 'type' => 'story', 'message' => 'Created a character.'}
        })
        
        set_achievements('events.yml', 'events', {
          "event_created" => { 'type' => 'community', 'message' => "Scheduled an event." }
        })

        set_achievements('forum.yml', 'forum', {
          "forum_reply" => { 'type' => 'community', 'message' => "Replied to a forum post." },
          "forum_post" => { 'type' => 'community', 'message' => "Created a forum post." }
        })
        
        set_achievements('friends.yml', 'friends', {
          "friend_added" => { 'type' => 'community', 'message' => "Added a friend." }
        })
        
        set_achievements('fs3combat_misc.yml', 'fs3combat', {
          "fs3_hero" => { 'type' => 'fs3', 'message' => "Heroed from a knockout." },
          "fs3_joined_combat" => { 'type' => 'fs3', 'message' => "Joined %{count} combats." }
        })
        
        set_achievements('fs3skills_misc.yml', 'fs3skills', {
          "fs3_luck_spent" => { 'type' => 'fs3', 'message' => "Spent a luck point." },
          "fs3_roll"  => { 'type' => 'fs3', 'message' => "Rolled a skill." }
        })
        
        set_achievements('profile.yml', 'profile', {
          "profile_edit" => { 'type' => 'portal', 'message' => "Edited your character profile." }
        })
        
        set_achievements('scenes.yml', 'scenes', {
          "word_count" => { 'type' => 'story', 'message' => "Wrote %{count} words in scenes." },
          "scene_participant" => { 'type' => 'story', 'message' => "Participated in %{count} scenes." }
        })
        
        set_achievements('website.yml', 'website', {
          "wiki_create" => { 'type' => 'portal', 'message' => "Created a wiki page." },
          "wiki_edit" => { 'type' => 'portal', 'message' => "Edited a wiki page." }
        })
        
        if (File.exist?(File.join(AresMUSH.game_path, 'config', 'cookies.yml')))
          set_achievements('cookies.yml', 'cookies', {
            "cookie_given" => { 'type' => 'community', 'message' => "Gave a cookie." },
            "cookie_received" => { 'type' => 'community', 'message' => "Received %{count} cookies." }
          })
        end

        Global.config_reader.load_game_config
        
        Character.all.each do |c|
          c.achievements.each do |achievement|
            if (achievement.name =~ /fs3_joined_combat_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'fs3_joined_combat', count)
              achievement.delete
            end

            if (achievement.name =~ /word_count_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'word_count', count)
              achievement.delete
            end

            if (achievement.name =~ /scene_participant_/)
              count = achievement.name.split('_').last.to_i
              if (count > 0)
                Achievements.award_achievement(c, 'scene_participant', count)
                achievement.delete
              end
            end
            
            if (achievement.name =~ /cookie_received_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'cookie_received', count)
              achievement.delete
            end
          end
        end
      end 
      
      def set_achievements(filename, section, data)
        config = DatabaseMigrator.read_config_file(filename)
        if (!config[section]['achievements'])
          config[section]['achievements'] = data
        end
        config = DatabaseMigrator.write_config_file(filename, config)
        
      end
    end
  end
end
