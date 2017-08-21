module AresMUSH
  class WebApp
   
    get '/wiki/?' do 
      redirect '/wiki/home'
    end
    
    get '/wiki/all/?' do
      @tag = "All Pages"
      @pages = WikiPage.all.to_a.sort_by { |p| p.display_title }
      erb :"wiki/tag"
    end
    
    get '/wiki/tag/:tag/?' do |tag|
      @tag = tag.titlecase
      @pages = WikiPage.all.select { |p| p.tags.include?(tag.downcase) }.sort_by { |p| p.display_title }
  
      erb :"wiki/tag"
    end

    get '/wiki/tags/?' do 
      @tags = []
      WikiPage.all.each do |p|
        @tags = @tags.concat p.tags
      end
  
      erb :"wiki/tags"
    end
    
    get '/wiki/create', :auth => :approved do
      @name = params[:name] || ""
      @title =@name.titleize
      
      erb :"wiki/create_page"
    end
    
    get '/wiki/:page/source/:version/?' do |name_or_id, version_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      @version = WikiPageVersion[version_id]
      
      if (!@page || !@version)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      @page_title = @page.display_title  
            
      erb :"wiki/page_source"
    end
    
    get '/wiki/:page/edit/?', :auth => :approved  do |name_or_id|
      
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      if (@page.is_special_page? && !is_admin?)
        flash[:error] = "You are not allowed to do that."
        redirect '/wiki'
      end
      
      erb :"wiki/edit_page"
    end
    
   
    get '/wiki/:page/revert/:version/?', :auth => :approved  do |name_or_id, version_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      @version = WikiPageVersion[version_id]
      
      if (!@page || !@version)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      
      WikiPageVersion.create(wiki_page: @page, text: @version.text)
      
      flash[:info] = "Page updated!"
      redirect "/wiki/#{@page.name}"
    end

    get '/wiki/:page/delete', :auth => :admin do |name_or_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      erb :"wiki/delete_page"
    end
    
    get '/wiki/:page/delete/confirm', :auth => :admin do |name_or_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      if (!@page)
        flash[:error] = "Page not found!"
        redirect '/wiki'
      end
      @page.delete
      flash[:info] = "Page deleted."
      redirect '/wiki'
    end
    
    ## IMPORTANT!!!!!!!!!!
    ## Make sure this route is always at the end of the file.
    
    get '/wiki/:page/?' do |name_or_id|
      @page = WikiPage.find_by_name_or_id(name_or_id)
      
      if (!@page)
        flash[:info] = "Page not found.  Do you want to create it?"
        redirect "/wiki/create?name=#{name_or_id}"
      end
            
      @page_title = @page.display_title  
            
      erb :"wiki/page"
    end
    
        
  end
end
