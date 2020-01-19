module AresMUSH
  module Utils
    class GetNotesRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        edit_mode = request.args[:edit_mode]
        enactor = request.enactor
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        error = Website.check_login(request)
        return error if error
        
        notes = []
        
        Utils.note_sections.each do |section|
          next if !Utils.can_access_notes?(char, enactor, section)
          if (edit_mode)
            formatted_text = Website.format_input_for_html(char.notes[section])
          else
            formatted_text = Website.format_markdown_for_html(char.notes[section])
          end
          
          notes << { name: section.titlecase, key: section, notes: formatted_text }
        end
        
        { 
          id: char.id,
          name: char.name,
          notes: notes,
          can_edit: char == enactor || Utils.can_manage_notes?(enactor)
        }
      end
    end
  end
end