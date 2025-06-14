module AresMUSH
  module Describe
    
    def self.desc_template(model, enactor)     
      if (model.class == Room)
        template = RoomTemplate.new(model, enactor)
      elsif (model.class == Character)
        template = CharacterTemplate.new(model)
      elsif (model.class == Exit)
        template = ExitTemplate.new(model)
      else
        raise "Invalid model type: #{model}"
      end
      template
    end
    
    def self.app_review(char)
      has_desc = char.description && !char.description.blank?
      error = has_desc ? t('chargen.ok') : t('chargen.not_set')
      Chargen.format_review_status t('describe.description_review'), error
    end
    
    def self.format_exit_name(ex)
      start_bracket = Global.read_config("describe", "exit_start_bracket")
      end_bracket = Global.read_config("describe", "exit_end_bracket")
      "#{start_bracket}#{ex.name}#{end_bracket}"
    end
    
    def self.get_web_descs_for_edit(model)
      if (model.kind_of?(Character))
        outfits = model.outfits.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_input_for_html(desc), key: index }}
      else
        outfits = nil
      end
      
      {
        current: Website.format_input_for_html(model.description),
        outfits: outfits,
        details: model.details.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_input_for_html(desc), key: index }}
      }
    end
    
    def self.get_web_descs_for_display(model)
      if (model.kind_of?(Character))
        outfits = model.outfits.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_markdown_for_html(desc), key: index }}
      else
        outfits = nil
      end
      
      {
        current: Website.format_markdown_for_html(model.description),
        outfits: outfits,
        details: model.details.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_markdown_for_html(desc), key: index }}
      }
    end
    
    def self.save_web_descs(model, data)
      model.update_desc(Website.format_input_for_mush(data['current']))
      if (model.kind_of?(Character))
        outfits = {}
        (data['outfits'] || []).each do |name, desc|
          outfits[name.titlecase] =  Website.format_input_for_mush(desc)
        end
        model.update(outfits: outfits)
        model.update(shortdesc: data['short'])
      end
      details = {}
      (data['details'] || []).each do |name, desc|
        details[name.titlecase] =  Website.format_input_for_mush(desc)
      end
      model.update(details: details)
    end
    
    def self.build_web_profile_data(char, viewer)
      { 
        description: Website.format_markdown_for_html(char.description),
        details: char.details.map { |name, desc| {
          name: name,
          desc: Website.format_markdown_for_html(desc)
          }},
        shortdesc: Website.format_markdown_for_html(char.shortdesc) 
      }      
    end
    
    def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
      {
        desc: Website.format_input_for_html(char.description),
        shortdesc: char.shortdesc ? char.shortdesc : '',
        descs: Describe.get_web_descs_for_edit(char)
      }
    end
    
    def self.export_descs(char)
      template = BorderedDisplayTemplate.new char.description
      output = template.render
      
      outfits = char.outfits.map { |k, v| "#{k}: #{v}"}.join("%R%R")
      template = BorderedDisplayTemplate.new outfits, t('describe.your_outfits')
      output << "%R%R"
      output << template.render
      
      output
    end
  end
end
