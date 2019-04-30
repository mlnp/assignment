class Url < ApplicationRecord
	validates :code, format: { with: /\A[a-zA-Z0-9]+\z/, message: "must be alphanumeric" }
	validates :url, :code, presence: true
	validates :code, uniqueness: true
end
