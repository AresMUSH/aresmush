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
      queue.each do |char, action|
        name = char.is_approved? ? "%xh%xg#{char.name}%xn" : char.name
        list << "#{name} - #{action}"
      end
      BorderedDisplay.list list, t('idle.idle_title')
    end
  end
end