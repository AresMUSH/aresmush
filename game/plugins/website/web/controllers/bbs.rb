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
    
    get '/bbs' do
      @boards = BbsBoard.all_sorted
      erb :"bbs/index"
    end
    
    get '/bbs/:id' do |id|
      @board = BbsBoard[id]
      if (!can_read_bbs?(@board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
        
      erb :"bbs/board"
    end
    
    get '/bbs/:board_id/:post_id' do |board_id, post_id|
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
    
    post '/bbs/reply', :auth => :approved do
      id = params[:post_id]
      message = format_input_for_mush params[:message]
      
      post = BbsPost[id]
      board = post.bbs_board
      if (!can_write_bbs?(board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
      
      if (message.blank?)
        flash[:error] = "Message required."
        redirect "/bbs/#{board.id}/#{post.id}"
      end
      
      Bbs.reply(board, post, @user, message)
      redirect "/bbs/#{board.id}/#{post.id}"
    end
    
    post '/bbs/post', :auth => :approved do
      id = params[:board_id]
      subject = params[:subject]
      message = format_input_for_mush params[:message]
      
      board = BbsBoard[id]
      if (!can_write_bbs?(board))
        flash[:error] = "You don't have access to that board."
        redirect '/bbs'
      end
      
      if (subject.blank? || message.blank?)
        flash[:error] = "Subject and message required."
        redirect "/bbs/#{board.id}"
      end
      
      
      post = Bbs.post(board.name, subject, message, @user)
      redirect "/bbs/#{board.id}/#{post.id}"
    end
  end
end
