module AresMUSH
  class WebApp
    
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
