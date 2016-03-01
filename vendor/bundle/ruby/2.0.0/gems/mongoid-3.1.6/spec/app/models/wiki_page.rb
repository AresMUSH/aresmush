class WikiPage
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :title, type: String
  field :transient_property, type: String, versioned: false
  field :author, type: String
  field :description, type: String, localize: true
  max_versions 5

  attr_protected :author

  has_many :comments, dependent: :destroy, validate: false
  has_many :child_pages, class_name: "WikiPage", dependent: :delete, inverse_of: :parent_pages
  belongs_to :parent_pages, class_name: "WikiPage", inverse_of: :child_pages
end
