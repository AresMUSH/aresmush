module AresMUSH
  module Forum
    class ForumListRequestHandler
      def handle(request)
                
        enactor = request.enactor

        error = WebHelpers.check_login(request, true)
        return error if error
        
        BbsBoard.all_sorted
           .select { |b| Forum.can_read_category?(enactor, b) }
           .map { |b| {
             id: b.id,
             name: b.name,
             description: b.description,
             unread: enactor && b.has_unread?(enactor)
           }}
        
      end
    end
  end
end