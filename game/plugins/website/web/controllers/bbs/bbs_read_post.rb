module AresMUSH
  class WebApp
    get '/bbs/:board_id/:post_id/?' do |board_id, post_id|
      @board = BbsBoard[board_id]
      @post = BbsPost[post_id]
      
      if (!can_read_bbs?(@board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
      
      if (@user)
        Bbs.mark_read_for_player(@user, @post)
      end
      
      erb :"bbs/post"
    end
  end
end
