module AresMUSH
  module Profile
    class ProfileEditRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name(request.args[:id])

        error = Website.check_login(request)
        return error if error

        if (!char)
          return { error: t('webportal.not_found') }
        end

        manager = Profile.can_manage_profiles?(enactor)

        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end

        if (!char.is_approved? && !manager)
          return { error: t('profile.not_yet_approved') }
        end

        demographics = {}
        profile = {}
        relationships = {}

        if (manager)
          props = Demographics.all_demographics
        else
          props = Global.read_config('demographics')['editable_properties']
        end

        props.each do |d|
          demographics[d.downcase] =
            {
              name: d.titlecase,
              value: char.demographic(d)
            }
        end

        profile = char.profile.sort.each_with_index.map { |(section, data), index|
          {
            name: section.titlecase,
            text: Website.format_input_for_html(data),
            key: index
          }
        }

        relationships = char.relationships.sort_by { |name, data| [ data['category'], data['order'] || 99, name ] }
          .each_with_index.map { |(name, data), index| {
          name: name,
          category: data['category'],
          key: index,
          order: data['order'],
          is_npc: data['is_npc'],
          npc_image: data['npc_image'],
          text: Website.format_input_for_html(data['relationship'])
        }}

        files = Profile.character_page_files(char)
        files = files.sort.map { |f| Website.get_file_info(f) }


        {
          id: char.id,
          name: char.name,
          demographics: demographics,
          background: Website.format_input_for_html(char.background),
          rp_hooks: Website.format_input_for_html(char.rp_hooks),
          plot_prefs: Website.format_input_for_html(char.plot_prefs),
          desc: Website.format_input_for_html(char.description),
          shortdesc: char.shortdesc ? char.shortdesc : '',
          relationships: relationships,
          relationships_category_order: char.relationships_category_order.join(","),
          profile: profile,
          profile_gallery: (char.profile_gallery || []).join(' '),
          tags: char.profile_tags,
          files: files,
          profile_image: char.profile_image ? Website.get_file_info(char.profile_image) : nil,
          profile_icon: char.profile_icon ? Website.get_file_info(char.profile_icon) : nil,
          bg_shared: char.bg_shared,
          lastwill: Website.format_input_for_html(char.idle_lastwill),
          custom: CustomCharFields.get_fields_for_editing(char, enactor),
          descs: Describe.get_web_descs_for_edit(char),
          genders: Demographics.genders
        }
      end
    end
  end
end
