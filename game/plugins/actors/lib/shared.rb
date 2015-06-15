module AresMUSH
  module Actors
    def self.can_set_actor?(char)
      char.has_any_role?(Global.read_config("actors", "roles", "can_set_actors"))
    end
    
    def self.create_or_update_actor(client, charname, actorname)
      actor_char = ClassTargetFinder.find(charname, Character, client)
      if (actor_char.found?)
        charname = actor_char.target.name
      end
      
      actor = ActorRegistry.all.select { |a| a.charname.upcase == charname.upcase }
      
      if (actor.empty?)
        ActorRegistry.create(charname: charname, character: actor_char.target, actor: actorname)
      else
        actor[0].actor = actorname
        actor[0].save
      end
    end
  end
end
