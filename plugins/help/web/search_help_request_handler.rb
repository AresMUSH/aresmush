module AresMUSH
  module Help
    class SearchHelpRequestHandler
      def handle(request)

        search_text = (request.args[:searchText] || "").strip

        topics = Help.find_quickref(search_text)
        topic_keys = topics.values.uniq
       
        {
          probable_matches: topic_keys.map { |t| 
            {
              id: t,
              name: t.humanize.titleize,
              summary: (Help.topic_index[t] || {})['summary']
            }
          }
        }
        
      end
      
      def line_is_match?(line, search)
        return true if line.start_with?("`#{search}")
        
        search = search.gsub(' ', '/')
        return line.start_with?("`#{search}")
      end
      
    end
  end
end