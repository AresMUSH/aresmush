module AresMUSH
  module Idle
    def self.can_idle_sweep?(actor)
      actor.has_any_role?(Global.read_config("idle", "roles", "can_idle_sweep"))
    end

    def self.is_exempt?(actor)
      actor.has_any_role?(Global.read_config("idle", "roles", "idle_exempt"))
    end
    
    def self.print_idle_queue(client)
      queue = client.program[:idle_queue]
      return t('idle.idle_not_started') if !queue

      list = []
      queue.each do |id, action|
        char = Character.find(id)
        name = char.is_approved? ? "%xh%xg#{char.name}%xn" : char.name
        last_on = OOCTime.local_short_timestr(client, char.last_on)
        will = char.lastwill
        list << "#{name.ljust(20)} #{last_on.ljust(12)} #{action.ljust(15)} #{will}"
      end
      BorderedDisplay.subtitled_list list, t('idle.idle_title'), t('idle.idle_subtitle')
    end
    
    def self.active_chars
      base_list = Character.where(:idled_out.exists => false, :idled_out.ne => "", :is_playerbit.ne => true)
      base_list.select { |c| !(c.is_admin? || Login::Interface.is_guest?(c))}
    end
    
  end
end