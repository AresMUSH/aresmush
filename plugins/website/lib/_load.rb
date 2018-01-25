$:.unshift File.dirname(__FILE__)

load "filename_sanitizer.rb"
load "create_wiki_page_handler.rb"
load "edit_wiki_page_handler.rb"
load "file_delete_request_handler.rb"
load "file_update_request_handler.rb"
load "file_upload_request_handler.rb"
load "get_files_request_handler.rb"
load "get_game_info_handler.rb"
load "get_sidebar_info_handler.rb"
load "get_wiki_page_handler.rb"
load "get_wiki_page_list_handler.rb"
load "get_wiki_source_handler.rb"
load "get_wiki_tag_list_handler.rb"
load "get_wiki_tag_handler.rb"
load "wiki_preview_request_handler.rb"
load "get_recent_changes_handler.rb"
load "get_config_request_handler.rb"
load "get_log_request_handler.rb"
load "get_logs_request_handler.rb"
load "get_tinker_request_handler.rb"
load "save_tinker_request_handler.rb"
load "save_config_request_handler.rb"

load "helpers/wiki_markdown/tag_match_helper.rb"
load "helpers/wiki_markdown/collapsible.rb"
load "helpers/wiki_markdown/char_gallery.rb"
load "helpers/wiki_markdown/div_block.rb"
load "helpers/wiki_markdown/image.rb"
load "helpers/wiki_markdown/include.rb"
load "helpers/wiki_markdown/music_player.rb"
load "helpers/wiki_markdown/page_list.rb"
load "helpers/wiki_markdown/scene_list.rb"
load "helpers/wiki_markdown/span_block.rb"
load "helpers/wiki_markdown/speech_bracket.rb"
load "helpers/wiki_markdown/wikidot_compatibility.rb"
load "helpers/wiki_markdown/markdown_finalizer.rb"
load "helpers/wiki_markdown/wiki_markdown_extensions.rb"
load "helpers/wiki_markdown/wiki_markdown_formatter.rb"
load "helpers/recaptcha_helper.rb"
load "helpers/web_helpers.rb"

load "wiki_page.rb"
load "wiki_page_version.rb"
