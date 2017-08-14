module AresMUSH
  class WebApp
    get '/help' do
      @topics = {}
      
      Help.toc.each do |toc|
        @topics[toc] = Help.toc_topics(toc)
      end
      
      uncategorized =  Help.toc_topics(nil)
      if (uncategorized.count > 0)
        @topics["Uncategorized"] = uncategorized
      end
      
      erb :"help/help_index"
    end
  end
end
