class Call
  include Mongoid::Document
  include Mongoid::Slug
  field :name, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :published, type: Mongoid::Boolean
  field :overview, type: String
  slug :name
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true,  reject_if: :all_blank
  
  embeds_many :questions, cascade_callbacks: true
  accepts_nested_attributes_for :questions, allow_destroy: true,  reject_if: :all_blank
  
  embeds_many :submissions,  cascade_callbacks: true
end