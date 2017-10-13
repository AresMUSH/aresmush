module AresMUSH
  class WebApp
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
    
  end
end
