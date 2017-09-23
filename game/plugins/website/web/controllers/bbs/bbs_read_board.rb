module AresMUSH
  class WebApp    
    get '/bbs/:id/?' do |id|
      @board = BbsBoard[id]
      if (!can_read_bbs?(@board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
        
      erb :"bbs/board"
    end
  end
end
