$:.unshift File.dirname(__FILE__)

load "bbs_api.rb"
load "helpers.rb"
load "bbs_board.rb"
load "bbs_reply.rb"
load "bbs_post.rb"

load "add_post_request_handler.rb"
load "add_reply_request_handler.rb"
load "forum_category_request_handler.rb"
load "forum_list_request_handler.rb"
load "forum_topic_request_handler.rb"