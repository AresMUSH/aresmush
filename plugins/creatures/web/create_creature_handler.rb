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

        if (request.args[:name].blank?)
          return { error: t('webportal.missing_required_fields') }
        end



        major_school_name = request.args[:major_school]
        major_school_id = Global.read_config("schools", request.args[:major_school], "id")
        major_school = {:name => major_school_name, :id => major_school_id}

        minor_school_name = request.args[:minor_school]
        minor_school_id = Global.read_config("schools", request.args[:minor_school], "id")
        minor_school = {:name => minor_school_name, :id => minor_school_id}

        sapient = (request.args[:sapient] || "").to_bool



        creature = Creature.create(
          name: request.args[:name],
          pinterest: request.args[:pinterest],
          found: request.args[:found],
          sapient: sapient,
          language: request.args[:language],
          traits: request.args[:traits],
          society: request.args[:society],
          magical_abilities: request.args[:magical_abilities],
          events: request.args[:events],
          major_school: major_school,
          minor_school: minor_school
        )



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

        portal_ids = request.args[:portals] || []
        creature.portals.replace []

        portal_ids.each do |portal|
          portal = Portal.find_one_by_name(portal.strip)
          if (portal)
            Creatures.add_portal(creature, portal)
          end
        end

        Website.add_to_recent_changes('creature', t('creatures.creature_created', :name => creature.name), { id: creature.id }, enactor.name)

        { id: creature.id }
      end
    end
  end
end
