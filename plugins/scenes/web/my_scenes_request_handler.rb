module AresMUSH
  module Scenes
    class MyScenesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        if (error)
          return []
        end
        
        Scene.all.select { |s| !s.completed && Scenes.is_participant?(s, enactor) }.map { |s|
          {
            id: s.id,
            title: s.title,
            is_unread: s.is_unread?(enactor)
          }
        }
        
      end
    end
  end
end

