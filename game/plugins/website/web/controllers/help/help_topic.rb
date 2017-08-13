module AresMUSH
  class WebApp

    get '/help/:plugin' do |plugin|
      redirect "/help/#{plugin}/index"
    end

    get '/help/:plugin/:topic' do |plugin, topic|
      @topic = topic.titlecase
      
      help = Help.all_help_topics.select { |k, v| v['plugin'] == plugin && v['topic'] == topic }
      
      if (help.keys.count == 0)
        flash[:error] = "Help topic not found!"
        redirect "/help"
      end
      
      md = MarkdownFile.new(help.values.first['path'])
      @help =  format_markdown_for_html(md.contents)
      erb :"help/help"
    end
    
  end
end
