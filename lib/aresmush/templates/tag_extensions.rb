module AresMUSH
  class TagExtensions
    def self.register
      Liquid::Template.register_tag('squish', AresMUSH::SquishTag)
      Liquid::Template.register_tag('center', AresMUSH::CenterTag)
      Liquid::Template.register_tag('c', AresMUSH::CenterTag)
      Liquid::Template.register_tag('left', AresMUSH::LeftTag)
      Liquid::Template.register_tag('l', AresMUSH::LeftTag)
      Liquid::Template.register_tag('right', AresMUSH::RightTag)
      Liquid::Template.register_tag('r', AresMUSH::RightTag)
      Liquid::Template.register_tag('line', AresMUSH::LineTag)
    end
  end
end
