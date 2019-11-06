module AresMUSH
  module Help
    class HelpIndexRequestHandler
      def handle(request)
        Help.toc.keys.sort.map { |toc| 
          {
            toc_category: toc,
            topics: build_topics(toc),
            tutorials: build_tutorials(toc)
          }
        }
      end
      
      def build_tutorials(toc)
        Help.toc_section_topic_data(toc)
        .select { |name, data| data['tutorial'] }
        .sort_by { |name, data| [ data['order'] || 99, name ] }
        .map { |name, data| 
          {
            topic: data['topic'],
            name: name.humanize.titleize,
            summary: data['summary']
          }
        }
      end
            
      def build_topics(toc)
        Help.toc_section_topic_data(toc)
        .select { |name, data| !data['tutorial'] }
        .sort_by { |name, data| [ data['order'] || 99, name ] }
        .map { |name, data| 
          {
            topic: data['topic'],
            name: name.humanize.titleize,
            summary: data['summary']
          }
        }
      end
    end
  end
end