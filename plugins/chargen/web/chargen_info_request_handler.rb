module AresMUSH
  module Chargen
    class ChargenInfoRequestHandler
      def handle(request)
        secret_config = Global.read_config('demographics', 'secret_prefs')
        secret_prefs = []
        secret_config.each do |k, v|
          secret_prefs << { desc: v, value: k }
        end

        lore_hook_config = Global.read_config('magic', 'lore_hook_prefs')
        lore_hook_prefs = []
        lore_hook_config.each do |k, v|
          lore_hook_prefs << { desc: v, value: k }
        end

        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::ChargenInfoRequestHandler.new.handle(request)
        else
          fs3 = nil
        end

        {
          fs3: fs3,
          group_options: Demographics::GroupInfoRequestHandler.new.handle(request),
          secret_prefs: secret_prefs,
          lore_hook_prefs: lore_hook_prefs,
          demographics: Demographics.public_demographics.map { |d| d.titlecase },
          date_format: Global.read_config("datetime", "date_entry_format_help"),
          intro_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "intro_blurb")),
          lorehook_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "lorehook_blurb")),
          bg_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "bg_blurb")),
          hooks_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "hooks_blurb")),
          desc_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "desc_blurb")),
          groups_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "groups_blurb")),
          icon_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "icon_blurb")),
          demographics_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "demographics_blurb")),
          lastwill_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "lastwill_blurb")),
          traits_blurb: Website.format_markdown_for_html(Global.read_config("traits", "traits_blurb")),          allow_web_submit: Global.read_config("chargen", "allow_web_submit"),
          genders: Demographics.genders
        }
      end
    end
  end
end
