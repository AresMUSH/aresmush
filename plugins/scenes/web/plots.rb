module AresMUSH
  class WebApp
    
    get '/plot/create/?', :auth => :approved do 
      erb :"plots/create_plot"
    end
    
    post '/plot/create', :auth => :approved do
      
      @plot = Plot.create(
      title: params[:title],
      description: params[:description],
      summary: params[:summary]
      )
      
      flash[:info] = "Plot created!"
      redirect "/plot/#{@plot.id}"
    end
    
    get '/plot/:id/edit/?', :auth => :approved do |id|
      @plot = Plot[id]
      
      if (!@plot)
        flash[:error] = "That plot does not exist."
        redirect "/plots"
      end
      
      erb :"plots/edit_plot"
    end
    
    post '/plot/:id/edit', :auth => :approved do |id|
      @plot = Plot[id]
      
      if (!@plot)
        flash[:error] = "That plot does not exist."
        redirect "/plots"
      end
      
      @plot.update(title: params[:title])
      @plot.update(description: params[:description])
      @plot.update(summary: params[:summary])
      
      flash[:info] = "Plot updated!"
      redirect "/plot/#{id}"
    end
    
    get '/plot/:id/delete', :auth => :admin do |id|
      @plot = Plot[id]
      
      if (!@plot)
        flash[:error] = "That plot does not exist."
        redirect "/plots"
      end
      
      
      erb :"/plots/delete_plot"
    end
    
    get '/plot/:id/delete/confirm', :auth => :admin do |id|
      @plot = Plot[id]
      
      if (!@plot)
        flash[:error] = "That plot does not exist."
        redirect "/plots"
      end
      @plot.delete
      flash[:info] = "Plot deleted!"
      redirect "/plots"
    end
    
    get '/plots/?' do
      @plots = Plot.all.to_a.sort_by { |p| p.id }
      erb :"plots/plots_index"
    end
    
    
    # MUST BE LAST
    get '/plot/:id/?' do |id|
      @plot = Plot[id]
      
      if (!@plot)
        flash[:error] = "That plot does not exist."
        redirect "/plots"
      end

      @page_title = @plot.title
      
      erb :"plots/plot"
    end
    
  end
end
