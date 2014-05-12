module AresMUSH
  module Bbs
    class BoardRenderer
      def initialize
        @renderer = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../../templates/board.erb")
      end
      
      def render(board, client)
        post_templates = board.bbs_posts.map { |p| BoardPostTemplate.new(p, client) }
        data = BoardTemplate.new(board, post_templates)
        @renderer.render(data)
      end
    end
  end
end