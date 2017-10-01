module AresMUSH
  class WebApp
    helpers do
      def can_read_bbs?(board)
        Bbs.can_read_board?(@user, board)
      end
      
      def can_write_bbs?(board)
        is_approved? && Bbs.can_write_board?(@user, board)
      end
    end
    
    get '/bbs/?' do
      @boards = BbsBoard.all_sorted
      erb :"bbs/bbs_index"
    end
    
    get '/bbs/:id/?' do |id|
      @board = BbsBoard[id]
      if (!can_read_bbs?(@board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
        
      erb :"bbs/board"
    end
    
    get '/bbs/:board_id/post/?' do |board_id|
      @board = BbsBoard[board_id]
      if (!can_write_bbs?(@board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
      
      erb :"bbs/new_post"
    end
    
    # Must be last!
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
