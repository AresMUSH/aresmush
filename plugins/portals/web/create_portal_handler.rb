module AresMUSH
  module Portals
    class PortalCreateRequestHandler
      def handle(request)

        enactor = request.enactor

        Global.logger.debug "Request: #{request.args.to_a} "

        error = Website.check_login(request)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        [ :name, :primary_school ].each do |field|
          if (request.args[field].blank?)
            return { error: t('webportal.missing_required_fields') }
          end
        end

        all_schools_names = request.args[:all_schools]
        all_schools = []
        if all_schools_names
          all_schools_names.each do |school|
            school_name = Global.read_config("schools", school, "name")
            all_schools_id = Global.read_config("schools", school, "id")
            new_school = [{:name => school_name, :id => all_schools_id}]
            all_schools.concat new_school
          end
        end

        school_name = request.args[:primary_school].to_s
        school_id = Global.read_config("schools", school_name, "id")
        primary_school = {:name => school_name, :id => school_id}

        portal = Portal.create(
          name: request.args[:name],

          pinterest: request.args[:pinterest],
          all_schools: all_schools,
          primary_school: primary_school,
          other_creatures: request.args[:other_creatures],
          npcs: request.args[:npcs],
          location: request.args[:location],
          description: request.args[:description],
          events: request.args[:events],
          trivia: request.args[:trivia],
          society: request.args[:society]
        )

        Global.logger.debug "Portal #{portal.id} (#{portal.name}) created by #{enactor.name}."

        gm_names = request.args[:gms] || []
        portal.gms.replace []

        gm_names.each do |gm|
          gm = Character.find_one_by_name(gm.strip)
          if (gm)
            if (!portal.gms.include?(gm))
              Portals.add_gm(portal, gm)
            end
          end
        end

        creature_ids = request.args[:creatures] || []
        portal.creatures.replace []

        creature_ids.each do |creature|
          creature = Creature.find_one_by_name(creature.strip)
          if (creature)
            if (!portal.creatures.include?(creature))
              Portals.add_creature(portal, creature)
            end
          end
        end

        { id: portal.id }

      end
    end
  end
end
