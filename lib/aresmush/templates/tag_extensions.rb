module AresMUSH
  class TagExtensions
    def self.register
      Liquid::Template.register_tag('strip', AresMUSH::StripTag)
      Liquid::Template.register_tag('center', AresMUSH::CenterTag)
      Liquid::Template.register_tag('left', AresMUSH::LeftTag)
      Liquid::Template.register_tag('right', AresMUSH::RightTag)
      Liquid::Template.register_tag('line', AresMUSH::LineTag)
    end
  end
end
