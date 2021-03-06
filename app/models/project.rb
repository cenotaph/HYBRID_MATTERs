class Project
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Taggable


  field :year_range, type: String
  field :name, type: String
  field :subtitle, type: String
  field :slug, type: String
  field :description, type: String
  field :image, type: String
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_size, type: String
  field :image_content_type, type: String
  field :published, type: Mongoid::Boolean
  field :redirect_url, type: String
  field :ongoing, type: Mongoid::Boolean
  field :is_featured, type: Mongoid::Boolean
  field :short_abstract, type: String

  # search_in :description, :title, :subtitle
  index({ description: "text", title: "text", subtitle: "text" })
  field :has_groups, type: Boolean
  field :custom_background_colour, type: String
  field :custom_background_image, type: String
  field :custom_body_background_image, type: String
  field :custom_heading_background_colour, type: String


  belongs_to :node, optional: true
  belongs_to :subsite, optional: true
  
  mount_uploader :image, ImageUploader
  mount_uploader :custom_background_image, BackgroundUploader
  mount_uploader :custom_body_background_image, BackgroundUploader

  slug :name, history: true
  include Imageable

  validates_uniqueness_of :name
  before_save :update_image_attributes
  has_and_belongs_to_many :partners
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :pages
  has_and_belongs_to_many :activities
  has_many :calls
  has_and_belongs_to_many :artists
  accepts_nested_attributes_for :artists
  scope :published, ->() { where(published: true) }
  scope :ongoing, ->() { where(ongoing: true) }
  scope :featured, ->() { where(is_featured: true) }
  scope :older, -> () {where(:ongoing.in => ["", nil, false])}

  search_in :name, :description, :subtitle
  def self.search(q)
    Project.where({ :$text => { :$search => q, :$language => "en" } })
  end

  def to_hashtag
    "##{name.gsub(/\s*/, '')}"
  end

  def index_image
    image? ? "background: #{custom_heading_background_colour.blank? ? '#d8d9db' : custom_heading_background_colour} url(#{image.url}) center center no-repeat;" : ''
  end

end
