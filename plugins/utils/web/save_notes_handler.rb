module AresMUSH
  module Utils
    class SaveNotesRequestHandler
      def handle(request)
        char = Character[request.args[:id]]
        notes = request.args[:notes]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        new_notes = char.notes
        
        notes.each do |section, text|
          next if !Utils.can_access_notes?(char, enactor, section)
          new_notes[section] = Website.format_input_for_mush(text)
        end
        
        char.update(notes: new_notes)
        
        {
        }
      end
    end
  end
end