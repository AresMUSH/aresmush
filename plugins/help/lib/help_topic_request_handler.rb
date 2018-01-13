module AresMUSH
  module Help
    class HelpTopicRequestHandler
      def handle(request)
        topic_id = request.args[:topic]
        topics = Help.find_topic(topic_id)
      
        if (topics.empty?)
          return { error: "Help topic not found." }
        end
      
        topic = topics.first
        contents = Help.topic_contents(topic)

        {
          name: topic.titleize,
          help: WebHelpers.format_markdown_for_html(contents)
        }
      end
    end
  end
end