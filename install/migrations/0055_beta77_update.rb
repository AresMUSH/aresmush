module AresMUSH  

  module Migrations
    class MigrationBeta77Update
      def require_restart
        false
      end
      
      def migrate
        
        Global.logger.debug "Adding notice shortcut."
        config = DatabaseMigrator.read_config_file("login.yml")
        shortcuts = config['login']['shortcuts']
        shortcuts.delete 'motd'
        shortcuts['notice'] = 'notices'
        config['login']['shortcuts'] = shortcuts
        DatabaseMigrator.write_config_file("login.yml", config)
        
        Global.logger.debug "Updating timestamps on login notices"
        LoginNotice.all.select { |n| !n.timestamp }.each { |n| n.update(timestamp: n.created_at)}
        
        Global.logger.debug "New combat achivements"
        config = DatabaseMigrator.read_config_file('fs3combat_misc.yml')
        config['fs3combat']['achievements']['fs3_wounded'] = {
          'type' => 'fs3', 'message' => 'Wounded %{count} times in combat.'
        }
        config['fs3combat']['achievements']['fs3_hard_hitter'] = {
          'type' => 'fs3', 'message' => 'Incapacitated an opponent in combat.'
        }
        config['fs3combat']['achievements']['fs3_explosive_hit'] = {
          'type' => 'fs3', 'message' => 'Did damage with an explosive weapon.'
        }
        config['fs3combat']['achievements']['fs3_melee_hit'] = {
          'type' => 'fs3', 'message' => 'Did damage with a melee weapon.'
        }
        config['fs3combat']['achievements']['fs3_ranged_hit'] = {
          'type' => 'fs3', 'message' => 'Did damage with a ranged weapon.'
        }
        config['fs3combat']['achievements']['fs3_suppressed'] = {
          'type' => 'fs3', 'message' => 'Suppressed a target in combat.'
        }
        config['fs3combat']['achievements']['fs3_subdued'] = {
          'type' => 'fs3', 'message' => 'Subdued a target in combat.'
        }
        config['fs3combat']['achievements']['fs3_distracted'] = {
          'type' => 'fs3', 'message' => 'Distracted a target in combat.'
        }
        config['fs3combat']['achievements']['fs3_rallied'] = {
          'type' => 'fs3', 'message' => 'Rallied a teammate in combat.'
        }
        config['fs3combat']['achievements']['fs3_treated'] = {
          'type' => 'fs3', 'message' => 'Treated a teammate in combat.'
        }
        config = DatabaseMigrator.write_config_file('fs3combat_misc.yml', config)
        
        Global.logger.debug "Clear scene deletion warnings."
        Scene.all.each { |s| s.update(deletion_warned: false) }
        
        Global.logger.debug "Convert channel messages to objects."
        Channel.all.each do |c|
          next if c.channel_messages.count > 0
          c.messages.each do |m|
            msg = m['message']
            author = Character.named(msg.split.first)
            chanmsg = ChannelMessage.create(character: author || Game.master.system_character,
             message: msg, channel: c)
             chanmsg.update(created_at: Time.parse(m['timestamp']))
          end
        end
      end 
    end    
  end
end