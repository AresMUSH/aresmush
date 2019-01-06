module AresMUSH
  module Help
    class SearchHelpRequestHandler
      def handle(request)

        searchText = (request.args[:searchText] || "").strip

        if (searchText.blank?)
          topics_by_name = {}
          topics_by_text = {}
        else
          topics_by_name = Help.find_topic(searchText).uniq.sort
          topics_by_text = Global.help_reader.help_text.select { |k, v| v =~ /\b#{searchText}\b/i }.keys.uniq.sort
        end
        
        {
          probable_matches: topics_by_name.map { |t| 
            {
              id: t,
              name: t.titleize,
              summary: (Help.topic_index[t] || {})['summary']
            }
          },
          possible_matches: topics_by_text.empty? ? nil : topics_by_text.map { |t| 
            {
              id: t,
              name: t.titleize,
              summary: (Help.topic_index[t] || {})['summary']
            }
          }
        }
        
      end
    end
  end
end