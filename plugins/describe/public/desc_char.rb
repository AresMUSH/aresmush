module AresMUSH

  class Character
    attribute :desc_notify, :type => DataType::Boolean, :default => true
    attribute :description
    attribute :shortdesc
    attribute :outfits, :type => DataType::Hash, :default => {}
    attribute :details, :type => DataType::Hash, :default => {}

    # -------------------------------
    # Outfits
    # -------------------------------

    def has_outfit?(name)
      !!outfit(name)
    end

    def outfit(name)
      outfits[name]
    end
  end
end
