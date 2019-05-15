module AresMUSH
  module Portals
    class PortalEditRequestHandler
      def handle(request)
        Global.logger.debug "Edit Request: #{request.args}"
        portal = Portal.find_one_by_name(request.args[:id])
        Global.logger.debug "Edit Portal: #{portal}"
        Global.logger.debug "Edit PortalID: #{portal.id}"
        Global.logger.debug "PrimarySchoolArgs: #{request.args[:primary_school]}"
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end

        # error = Website.check_login(request, true)
        # return error if error
        #
        # if (!enactor.is_approved?)
        #   return { error: t('dispatcher.not_allowed') }
        # end

        Global.logger.debug "Portal #{portal.id} (#{portal.name} Portal) edited by #{enactor.name}."

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


          all_schools_names = request.args[:all_schools] || []
          portal.all_schools.replace []
          all_schools = []
          all_schools_names.each do |school|
            school_name = Global.read_config("schools", school, "name")
            id = Global.read_config("schools", school, "id")
            new_school = [{:name => school_name, :id => id}]
            all_schools.concat new_school
          end
          portal.update(all_schools: all_schools)


          school_name = request.args[:primary_school].to_s
          id = Global.read_config("schools", request.args[:primary_school], "id")
          Global.logger.debug "School Name #{school_name}"
          Global.logger.debug "School ID #{id}"
          primary_school = {:name => school_name, :id => id}
          Global.logger.debug "Primary School #{primary_school}"
          portal.update(primary_school: primary_school)



          Global.logger.debug "gms #{request.args[:gms]}"
          Global.logger.debug "all_schools #{request.args[:all_schools]}"

          portal.update(name: request.args[:name])
          portal.update(creatures: request.args[:creatures])
          portal.update(npcs: request.args[:npcs])
          portal.update(location: request.args[:location])
          portal.update(description: request.args[:description])
          portal.update(trivia: request.args[:trivia])
          portal.update(events: request.args[:events])
          {}
      end
    end
  end
end
