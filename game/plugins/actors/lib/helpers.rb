module AresMUSH
  module Actors
    def self.can_set_actor?(char)
      char.has_any_role?(Global.read_config("actors", "roles", "can_set_actors"))
    end
    
    def self.create_or_update_actor(enactor, charname, actorname)
      result = ClassTargetFinder.find(charname, Character, enactor)
      if (result.found?)
        charname = result.target.name
        actor_char = result.target
      end
      
      actor = ActorRegistry.all.select { |a| a.charname.upcase == charname.upcase }
      
      if (actor.empty?)
        a = ActorRegistry.create(charname: charname, character: actor_char, actor: actorname)
        if (actor_char)
          actor_char.actor_registry = a
          actor_char.save
        end
      else
        actor[0].actor = actorname
        actor[0].save
      end
    end
  end
end
