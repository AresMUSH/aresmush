module AresMUSH
  module Creatures
    class CreateCreatureRequestHandler
      def handle(request)

        enactor = request.enactor

        Global.logger.debug "REquest: #{request.args.to_a} "

        error = Website.check_login(request)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        # if (request.args[:name].blank?)
        #   return { error: t('webportal.missing_required_fields') }
        # end





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
          events: request.args[:events]
        )



        Global.logger.debug "Creature #{creature.id} (#{creature.name})created by #{enactor.name}."


        major_school_name = request.args[:major_school]
        id = Global.read_config("schools", request.args[:major_school], "id")
        major_school = {:name => major_school_name, :id => id}
        creature.update(major_school: major_school)


        minor_school_name = request.args[:minor_school]
        id = Global.read_config("schools", request.args[:minor_school], "id")
        minor_school = {:name => minor_school_name, :id => id}
        creature.update(minor_school: minor_school)


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

        { id: creature.id }
      end
    end
  end
end
