module AresMUSH
  module Pf2e
    class FeatSearchTemplate < ErbTemplateRenderer

      attr_accessor :paginator, :query

      def initialize(paginator, query = nil)
        @paginator = paginator
        @query = query
        super File.dirname(__FILE__) + "/feat_search.erb"
      end

      def title
        if @query.to_s.strip.empty?
          t('pf2e.feat_search_title_all')
        else
          t('pf2e.feat_search_title_query', :query => @query)
        end
      end
    end
  end
end
