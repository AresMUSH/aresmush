module AresMUSH
  module Creatures
    class CreateCreatureRequestHandler
      def handle(request)

        enactor = request.enactor

        error = Website.check_login(request)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        if (request.args[:name].blank? || request.args[:short_desc].blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        sapient = (request.args[:sapient] || "").to_bool

        creature = Creature.create(
          name: request.args[:name],
          pinterest: request.args[:pinterest],
          found: request.args[:found],
          sapient: sapient,
          traits: request.args[:traits],
          society: request.args[:society],
          combat: request.args[:combat],
          magical_abilities: request.args[:magical_abilities],
          events: request.args[:events],
          short_desc: request.args[:short_desc],
        )


        banner_image = Creatures.build_image_path(creature, request.args[:banner_image])
        profile_image = Creatures.build_image_path(creature, request.args[:profile_image])

        creature.update(banner_image: banner_image)
        creature.update(profile_image: profile_image)

        Global.logger.debug "Creature #{creature.id} (#{creature.name}) created by #{enactor.name}."


        gm_names = request.args[:gms] || []
        creature.gms.replace []

        gm_names.each do |gm|
          gm = Character.find_one_by_name(gm.strip)
          if (gm)
            if (!creature.gms.include?(gm))
              Creatures.add_gm(creature, gm)
            end
          end
        end

        plot_ids = request.args[:plots] || []

        plot_ids.each do |plot|
          plot = Plot.find_one_by_name(plot.strip)
          if (plot)
            Creatures.add_plot(portal, plot)
          end
        end

        Website.add_to_recent_changes('creature', t('creatures.creature_created', :name => creature.name), { id: creature.id }, enactor.name)

        { id: creature.id }
      end
    end
  end
end
