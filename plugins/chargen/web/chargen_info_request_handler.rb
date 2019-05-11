module AresMUSH
  module Chargen
    class ChargenInfoRequestHandler
      def handle(request)
        group_config = Global.read_config('demographics', 'groups')
        
        groups = {}
        group_config.each do |type, data|
          groups[type.downcase] = {
            name: type,
            desc: data['desc'],
            values: (data['values'] || {}).map { |name, desc| { name: type.titleize, value: name, desc: desc } },
            freeform: !data['values']
          }
        end
        
        if (Ranks.is_enabled?)
          ranks = []
          
          group_config[Ranks.rank_group]['values'].each do |k, v|
            Ranks.allowed_ranks_for_group(k).each do |r|
              ranks << { name: 'Rank', value: r, desc: k }
            end
          end
          
          groups['rank'] = {
            name: 'Rank',
            desc: Global.read_config('chargen', 'rank_blurb'),
            values: ranks
          }
        end
        
        
        if (FS3Skills.is_enabled?)
          fs3 = FS3Skills::ChargenInfoRequestHandler.new.handle(request)
        else
          fs3 = nil
        end
        
        {
          fs3: fs3,
          group_options: groups,
          demographics: Demographics.public_demographics.map { |d| d.titlecase },
          date_format: Global.read_config("datetime", "date_entry_format_help"),
          bg_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "bg_blurb")),
          hooks_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "hooks_blurb")),
          desc_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "desc_blurb")),
          groups_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "groups_blurb")),
          demographics_blurb: Website.format_markdown_for_html(Global.read_config("chargen", "demographics_blurb")),
          allow_web_submit: Global.read_config("chargen", "allow_web_submit")
        }
      end
    end
  end
end


