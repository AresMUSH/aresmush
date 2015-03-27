module AresMUSH
  module Tinker
    class TinkerCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
            
      def want_command?(client, cmd)
        cmd.root_is?("tinker")
      end
      
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end
      
      def handle
        # Put whatever you need to do here.
        list = Global.config['fs3combat']['old_vehicles'].map { |w| print_wpn(w) }
        client.emit BorderedDisplay.list list
        client.emit_success "Done!"
      end
      
      def print_wpn(w)
        text = ""
#        fields = [ 'description', 'atack_skill',  'defense_skill', 'lethality', 'penetration', 'weapon_type', 'weapon_class', 'is_automatic', 'ammo', 'recoil', 'range', 'blast', 'damage_type', 'accuracy', 'has_shrapnel', 'reload_time' ]
#fields = [ 'desc', 'hitloc', 'protection', 'class' ]
fields = ['desc', 'pilotskill', 'toughness', 'armor', 'hitloc', 'weapons', 'dodge']
        w.split('|').each_with_index do |f, i|
          if (i == 0)
            x = f.split('=')
            name = x[0].after('_').before(' ').gsub(/_/, ' ').titleize
            text << "%R        #{name}:"
            text << "%R            description: \"#{x[1]}\""
          elsif (i == 5)
            x = f.split(' ')
            text << "%R            weapons:"
            x.each do |y|
              text << "%R                - #{y.gsub(/_/, ' ').titleize}"
            end
          elsif (i == 3)
            next
          else
            text << "%R            #{fields[i]}: #{f}"
          end
        end
        text
      end
    end
  end
end
