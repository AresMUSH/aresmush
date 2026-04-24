module AresMUSH
  module Profile
    class ProfileSourceRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args['char_id']
        version = ProfileVersion[request.args['version_id']]
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        if (!version)
          return { error: t('webportal.not_found') }
        end
        
        all_versions = char.profile_versions.to_a.sort_by { |v| v.created_at }
        
        current_index = all_versions.index { |v| v.id == version.id }
        if (!current_index || current_index < 0)
          return { error: t('webportal.not_found') }
        end
      
        previous_index = current_index - 1
        if (previous_index < 0)
          diff = nil
        else
          previous = all_versions[previous_index]
          diff = Diffy::Diff.new(previous.text, version.text).to_s(:html_simple)
        end
        
        {
          char_id: char.id,
          char_name: char.name,
          text: version.text,
          diff: diff,
          versions:  all_versions.reverse.map { |v| { id: v.id, created: v.created_at, author: v.author_name }},
          current_version: version.id
        }
      end
    end
  end
end