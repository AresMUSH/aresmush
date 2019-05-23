module AresMUSH
  module Creatures
    class CreatureRequestHandler
      def handle(request)
        Global.logger.debug "Creature request handler"
        Global.logger.debug "Request: #{request.args.to_a}"
        creature = Creature.find_one_by_name(request.args[:id])
        enactor = request.enactor

        if (!creature)
          return { error: t('webcreature.not_found') }
        end

        scenes_starring = Scene.creature_scenes(creature)

        scenes = scenes_starring.sort_by { |s| s.icdate || s.created_at }.reverse
             .map { |s| {
                      id: s.id,
                      title: s.title,
                      summary: s.summary,
                      location: s.location,
                      icdate: s.icdate,
                      participants: s.participants.to_a.sort_by { |p| p.name }.map { |p| { name: p.name, id: p.id, icon: Website.icon_for_char(p) }},
                      scene_type: s.scene_type ? s.scene_type.titlecase : 'Unknown',
                      likes: s.likes

                    }
                  }



        gms = creature.gms.to_a
            .sort_by {|gm| gm.name }
            .map { |gm| { name: gm.name, id: gm.id, is_ooc: gm.is_admin? || gm.is_playerbit?  }}

        portals = creature.portals.to_a
            .sort_by {|portal| portal.name }
            .map { |portal| { name: portal.name, id: portal.id }}

        if creature.sapient
          sapient = "Sapient"
        else
          sapient = "Non Sapient"
        end

        {
          name: creature.name,
          major_school: creature.major_school,
          minor_school: creature.minor_school,
          gms: gms,
          found: creature.found,
          portals: portals,
          sapient: sapient,
          id: creature.id,
          pinterest: creature.pinterest,
          language: creature.language,
          edit_traits: Website.format_input_for_html(creature.traits),
          traits: Website.format_markdown_for_html(creature.traits),
          edit_society:  Website.format_input_for_html(creature.society),
          society: Website.format_markdown_for_html(creature.society),
          edit_magical_abilities: Website.format_input_for_html(creature.magical_abilities),
          magical_abilities: Website.format_markdown_for_html(creature.magical_abilities),
          edit_events:  Website.format_input_for_html(creature.events),
          events: Website.format_markdown_for_html(creature.events),
          scenes: scenes
        }
      end

    end
  end
end
