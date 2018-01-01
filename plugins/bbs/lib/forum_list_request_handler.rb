module AresMUSH
  module Bbs
    class ForumListRequestHandler
      def handle(request)
                
        enactor = request.enactor
        
        BbsBoard.all_sorted
           .select { |b| Bbs.can_read_board?(enactor, b) }
           .map { |b| {
             id: b.id,
             name: b.name,
             unread: enactor && b.has_unread?(enactor)
           }}
        
      end
    end
  end
end