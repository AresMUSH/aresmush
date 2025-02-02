module AresMUSH
  module Website
    class GetWikiPageSourceRequestHandler
      def handle(request)
        page_id = request.args['page_id']
        version_id = request.args['version_id']
        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
              
        page = WikiPage.find_by_name_or_id(page_id)
        if (!page)
          return { error: t('webportal.not_found') }
        end
        
        version = WikiPageVersion[version_id]
        if (!version)
          return { error: t('webportal.not_found') }
        end
        
        all_versions = page.sorted_versions
        current_index = all_versions.index { |v| v.id == version.id }
        if (!current_index || current_index <= 0)
          diff = ""
        else
          previous = all_versions[current_index - 1]
          diff = Diffy::Diff.new(previous.text, version.text).to_s(:html_simple)
        end
      
        {
          page_id: page.id,
          version_id: version.id,
          name: page.name,
          title: page.title,
          heading: page.heading,
          text: version.text,
          diff: diff,
          created: OOCTime.local_long_timestr(enactor, version.created_at),
          can_edit: enactor && enactor.is_approved? && ( enactor.is_admin? || !Website.is_restricted_wiki_page?(page) ),
          versions: page.sorted_versions.reverse.map { |v| {
            author: v.author_name,
            id: v.id,
            created: OOCTime.local_long_timestr(enactor, v.created_at)
          }}
        }
      end
    end
  end
end