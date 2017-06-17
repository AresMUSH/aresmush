module AresMUSH
  class WebApp
    get '/help' do
      @topics = {}
      
      if (params[:list])
        show_full = true
      else
        show_full = false
      end
      
      Help.toc.each do |toc|
        if (show_full)
          @topics[toc] = Help.toc_topics(toc)
        else
          index_topics = Help.toc_topics(toc).select { |k, v| v['topic'] == 'index' }
          @topics[toc] = index_topics
        end
      end
      
      uncategorized =  Help.toc_topics(nil)
      if (uncategorized.count > 0)
        @topics["Uncategorized"] = uncategorized
      end
      
      if (show_full)
        erb :help_full_index
      else
        erb :help_index
      end
    end

    get '/help/:plugin/:topic' do |plugin, topic|
      @topic = topic.titlecase
      
      help = Help::Api.help_topics.select { |k, v| v['plugin'] == plugin && v['topic'] == topic }
      md = MarkdownFile.new(help.values.first['path'])
      text = ClientFormatter.format md.contents, false
      formatter = MarkdownFormatter.new
      @help =  formatter.to_html(text)
      erb :help
    end
  end
end
