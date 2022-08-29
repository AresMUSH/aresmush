module AresMUSH
  module Creatures
    class CreatureRequestHandler
      def handle(request)
        creature = Creature.find_one_by_name(request.args[:id])
        enactor = request.enactor

        if (!creature)
          return { error: t('creatures.creature_not_found') }
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

        plots = creature.plots.to_a
            .sort_by {|plot| plot.title }
            .map { |plot| { name: plot.title, id: plot.id }}

        if (creature.image_gallery.empty?)
          gallery_files = Creatures.creature_page_files(creature) || []
        else
          gallery_files = creature.image_gallery.select { |g| g =~ /\w\.\w/ }
        end

        files = Creatures.creature_page_files(creature)
        files = files.map { |f| Website.get_file_info(f) }

        {
          name: creature.name,
          gms: gms,
          found: creature.found,
          sapient: creature.sapient,
          id: creature.id,
          pinterest: creature.pinterest,
          edit_traits: Website.format_input_for_html(creature.traits),
          traits: Website.format_markdown_for_html(creature.traits),
          edit_society:  Website.format_input_for_html(creature.society),
          society: Website.format_markdown_for_html(creature.society),
          edit_magical_abilities: Website.format_input_for_html(creature.magical_abilities),
          magical_abilities: Website.format_markdown_for_html(creature.magical_abilities),
          edit_combat: Website.format_input_for_html(creature.combat),
          combat: Website.format_markdown_for_html(creature.combat),
          edit_events:  Website.format_input_for_html(creature.events),
          events: Website.format_markdown_for_html(creature.events),
          scenes: scenes,
          plots: plots,
          edit_short_desc: Website.format_input_for_html(creature.short_desc),
          short_desc: Website.format_markdown_for_html(creature.short_desc),
          banner_image: creature.banner_image ? Website.get_file_info(creature.banner_image) : nil,
          profile_image: creature.profile_image ? Website.get_file_info(creature.profile_image) : nil,
          image_gallery: (creature.image_gallery || []).join(' '),
          display_image_gallery: gallery_files.map { |g| Website.get_file_info(g) },
          files: files,
        }
      end

    end
  end
end
