module AresMUSH
  module Describe
<<<<<<< HEAD

    def self.desc_template(model, enactor)
=======
    
    def self.desc_template(model, enactor)     
>>>>>>> upstream/master
      if (model.class == Room)
        template = RoomTemplate.new(model, enactor)
      elsif (model.class == Character)
        template = CharacterTemplate.new(model)
      elsif (model.class == Exit)
        template = ExitTemplate.new(model)
<<<<<<< HEAD
      elsif (model.class == Mount)
        template = CharacterTemplate.new(model)
=======
>>>>>>> upstream/master
      else
        raise "Invalid model type: #{model}"
      end
      template
    end
<<<<<<< HEAD

=======
    
>>>>>>> upstream/master
    def self.app_review(char)
      has_desc = char.description && !char.description.blank?
      error = has_desc ? t('chargen.ok') : t('chargen.not_set')
      Chargen.format_review_status t('describe.description_review'), error
    end
<<<<<<< HEAD

=======
    
>>>>>>> upstream/master
    def self.format_exit_name(ex)
      start_bracket = Global.read_config("describe", "exit_start_bracket")
      end_bracket = Global.read_config("describe", "exit_end_bracket")
      "#{start_bracket}#{ex.name}#{end_bracket}"
    end
<<<<<<< HEAD

=======
    
>>>>>>> upstream/master
    def self.get_web_descs_for_edit(model)
      if (model.kind_of?(Character))
        outfits = model.outfits.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_input_for_html(desc), key: index }}
      else
        outfits = nil
      end
<<<<<<< HEAD

=======
      
>>>>>>> upstream/master
      {
        current: Website.format_input_for_html(model.description),
        outfits: outfits,
        details: model.details.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_input_for_html(desc), key: index }}
      }
    end
<<<<<<< HEAD

=======
    
>>>>>>> upstream/master
    def self.get_web_descs_for_display(model)
      if (model.kind_of?(Character))
        outfits = model.outfits.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_markdown_for_html(desc), key: index }}
      else
        outfits = nil
      end
<<<<<<< HEAD

=======
      
>>>>>>> upstream/master
      {
        current: Website.format_markdown_for_html(model.description),
        outfits: outfits,
        details: model.details.each_with_index.map { |(name, desc), index| { name: name, desc: Website.format_markdown_for_html(desc), key: index }}
      }
    end
<<<<<<< HEAD

=======
    
>>>>>>> upstream/master
    def self.save_web_descs(model, data)
      model.update(description: Website.format_input_for_mush(data['current']))
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
<<<<<<< HEAD

    def self.build_web_profile_data(char, viewer)
      {
=======
    
    def self.build_web_profile_data(char, viewer)
      { 
>>>>>>> upstream/master
        description: Website.format_markdown_for_html(char.description),
        details: char.details.map { |name, desc| {
          name: name,
          desc: Website.format_markdown_for_html(desc)
          }},
<<<<<<< HEAD
        shortdesc: Website.format_markdown_for_html(char.shortdesc)
      }
    end

=======
        shortdesc: Website.format_markdown_for_html(char.shortdesc) 
      }      
    end
    
>>>>>>> upstream/master
    def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
      {
        desc: Website.format_input_for_html(char.description),
        shortdesc: char.shortdesc ? char.shortdesc : '',
        descs: Describe.get_web_descs_for_edit(char)
      }
    end
  end
end
