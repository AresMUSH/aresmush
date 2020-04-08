module AresMUSH
  module Help
    class HelpTopicRequestHandler
      def handle(request)
        topic_id = request.args[:topic]
        topics = Help.find_topic(topic_id)

        enactor = request.enactor
        
        error = Website.check_login(request, true)
        return error if error
      
        if (topics.empty?)
          return { error: t('help.not_found', :topic => topic_id) }
        end
      
        topic = topics.first
        contents = Help.topic_contents(topic)
        topic_data = Help.topic_index[topic]
        
        file = File.read(topic_data['path'], :encoding => "UTF-8")
        
        {
          key: topic,
          is_override: topic_data['override'],
          name: topic.humanize.titleize,
          help: Website.format_markdown_for_html(contents),
          raw_contents: Website.format_input_for_html(file),
          can_manage: Manage.can_manage_game?(enactor),
          related_topics: Help.related_topics(topic).map { |r| {
            title: r.humanize.titleize,
            key: r }},
          section_title: (Help.topic_index[topic] || {})['toc']
        }
      end
    end
  end
end