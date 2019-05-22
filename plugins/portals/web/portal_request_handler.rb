module AresMUSH
  module Portals
    class PortalRequestHandler
      def handle(request)
        Global.logger.debug "Portal request handler"
        Global.logger.debug "Request: #{request.args.to_a}"
        portal = Portal.find_one_by_name(request.args[:id])
        Global.logger.debug "Portal: #{portal.name} #{portal.id}"
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end



        gms = portal.gms.to_a
            .sort_by {|gm| gm.name }
            .map { |gm| { name: gm.name, id: gm.id, is_ooc: gm.is_admin? || gm.is_playerbit?  }}

        creatures = portal.creatures.to_a
            .sort_by {|creature| creature.name }
            .map { |creature| { name: creature.name, id: creature.id }}


        all_schools = portal.all_schools.to_a

        {
          name: portal.name,
          primary_school: portal.primary_school,
          all_schools: all_schools,
          edit_other_creatures: Website.format_input_for_html(portal.other_creatures),
          other_creatures: Website.format_markdown_for_html(portal.other_creatures),
          edit_npcs:  Website.format_input_for_html(portal.npcs),
          npcs: Website.format_markdown_for_html(portal.npcs),
          gms: gms,
          creatures: creatures,
          location: portal.location,
          edit_desc: Website.format_input_for_html(portal.description),
          description: Website.format_markdown_for_html(portal.description),
          edit_trivia:  Website.format_input_for_html(portal.trivia),
          trivia: Website.format_markdown_for_html(portal.trivia),
          edit_events:  Website.format_input_for_html(portal.events),
          events: Website.format_markdown_for_html(portal.events),
          edit_society:  Website.format_input_for_html(portal.society),
          society: Website.format_markdown_for_html(portal.society),
          id: portal.id,
          pinterest: portal.pinterest
        }
      end

    end
  end
end
