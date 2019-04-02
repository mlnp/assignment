class Url < ApplicationRecord

  validates_uniqueness_of :shortcode
  validates :shortcode, length: { is: 6 }
  validates :url, presence: true
  validates :shortcode, format: {
    with: /\A[a-zA-Z0-9]*\z/,
    message: "must be alphanumeric with no spaces or special characters"
  }
  validate :check_url_validity

  before_validation :check_shortcode

  def generate_shortcode
    # BASE58_ALPHABET	=	("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a - ["0", "O", "I", "l"]
    self.shortcode = SecureRandom.base58(6)
  end

  private

    def check_shortcode
      logger.info "check_shortcode"
      if self.shortcode.blank?
        logger.info "No shortcode found; generating"
        self.generate_shortcode
      end
    end

    def check_url_validity
      logger.info "checking URL validity"
      uri = URI(self.url)
      logger.info "URL validity OK"
    rescue => err
      logger.error err
      self.errors.add(:url, :invalid_url, message: "must be a valid URL")
    end

end
