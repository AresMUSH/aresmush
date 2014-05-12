module AresMUSH
  module Bbs
    class BoardListRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/boards.erb")
      end
      
      def render(client)
        boards = BbsBoard.all_sorted        
        board_templates = boards.map { |b| BoardListBbsTemplate.new(b, client) }
        data = BoardListTemplate.new(board_templates)
        @renderer.render(data)
      end
    end
  end
end