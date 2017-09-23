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
  end
end
