module AresMUSH
  module Bbs
    class ForumListRequestHandler
      def handle(request)
                
        char_id = request.args[:char_id]
        if (char_id)
          char = Character.find_one_by_name(char_id)
          if (!char)
            return { error: "Character not found." }
          end
        else
          char = nil
        end
        
        BbsBoard.all_sorted
           .select { |b| Bbs.can_read_board?(char, b) }
           .map { |b| {
             id: b.id,
             name: b.name,
             unread: char && b.has_unread?(char)
           }}
        
      end
    end
  end
end