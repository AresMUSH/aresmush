module AresMUSH
  module Page
    class PageLogTemplate < ErbTemplateRenderer
      
      attr_accessor :pages, :chars, :enactor
      
      def initialize(enactor, pages, chars)
        @enactor = enactor
        @chars = chars
        @pages = pages
        super File.dirname(__FILE__) + "/page_log.erb"
      end


      def names
        @chars.map { |c| c.name }.join(" ")
      end
      
      def time(page)
        OOCTime.local_long_timestr(@enactor, page.created_at)
      end
    end
  end
end