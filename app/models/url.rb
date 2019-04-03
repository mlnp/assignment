class Url < ApplicationRecord

  validates_uniqueness_of :shortcode
  validates :url, presence: true
  validates :shortcode, length: { is: 6 }
  validates :shortcode, format: {
    with: /\A[a-zA-Z0-9]*\z/,
    message: "must be alphanumeric with no spaces or special characters"
  }
  validate :check_url_validity

  before_validation :add_url_protocol
  before_validation :check_shortcode

  attr_accessor :tests_action

  def generate_shortcode
    # BASE58_ALPHABET	=	("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a - ["0", "O", "I", "l"]
    self.shortcode = SecureRandom.base58(6)
  end

  def record_usage
    self.increment(:usage_count)
    self.last_usage = Time.current
    self.save
  end

  private

    def check_shortcode
      return if self.tests_action
      if self.shortcode.blank?
        logger.info "No shortcode found; generating"
        self.generate_shortcode
      end
    end

    def check_url_validity
      uri = URI(self.url)
      unless uri.scheme == "http" || uri.scheme == "https"
        self.errors.add(:url, :invalid_url, message: "must include http:// or https://")
      end
    rescue => err
      logger.error err
      self.errors.add(:url, :invalid_url, message: "must be a valid URL")
    end

    def add_url_protocol
      return if self.url.blank? || self.tests_action
      unless self.url.start_with?("http://", "https://")
        self.url = "http://#{self.url}"
      end
    end

end
