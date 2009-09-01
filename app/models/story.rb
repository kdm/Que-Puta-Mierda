class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :country  

  acts_as_commentable
  acts_as_taggable
  acts_as_mappable

  validates_presence_of   :body, :message => "Debes escribir una historia"
  validates_presence_of   :title, :message => "Debes poner un titulo"
  
    
  validates_length_of     :body,              :within => 40..10000, :message => "Al menos 40 letras"
  validates_presence_of :category_id, :message => "Elige una categoría"
  validates_presence_of :country_id, :message => "Elige una categoría"

  named_scope :moderated, :conditions => ['on_startpage = ?', true]
  named_scope :tops, :order => ['rated_top desc']
  named_scope :flops, :order => ['rated_flop desc']
  named_scope :newest_first, :order => ['created_at desc']
  named_scope :to_moderate, :conditions => ['on_startpage = ?', true]  
  named_scope :for_administering, :order => "created_at desc"


  
  has_friendly_id :seo_title, :use_slug => true, :strip_diacritics => true
  
  before_validation :generate_seo_title

  def tags_seperated
    tag_list.map { |tag|  tag+","}
  end

  def generate_seo_title
    if true #self.title.length > 30
      self.seo_title = self.title
    else
      self.seo_title = self.body[0..(60+ (self.body[60..100].index(" ")))]          
    end
  end

  def browser_title
    self.seo_title
  end


  # def to_param
  #   "#{id}-#{body[0..60].gsub(/[^a-z0-9]+/i, '-')}"
  # end




end
