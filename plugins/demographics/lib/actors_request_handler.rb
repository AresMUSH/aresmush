module AresMUSH
  module Demographics
    class ActorsRequestHandler
      def handle(request)
        chars_with_actors = Character.all
            .select { |c| !c.demographic(:actor).blank? }

        chars_with_actors.map{ |c| 
          {
            char_name: c.name,
            actor: c.demographic(:actor)
           }
         }.sort_by { |c| c[:actor]}
      end
    end
  end
end