class Url < ApplicationRecord

  validates_uniqueness_of :shortcode
  validates :shortcode, length: { is: 6 }

end
