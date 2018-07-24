module AresMUSH
  module Help
    class HelpTopicRequestHandler
      def handle(request)
        topic_id = request.args[:topic]
        topics = Help.find_topic(topic_id)
      
        if (topics.empty?)
          return { error: t('help.not_found', :topic => topic_id) }
        end
      
        topic = topics.first
        contents = Help.topic_contents(topic)

        {
          name: topic.titleize,
          help: Website.format_markdown_for_html(contents)
        }
      end
    end
  end
end