class PasswordEntry < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :website_url, presence: true
  validates :username, presence: true
  validates :encrypted_password, presence: true

  # Active Record Encryption for sensitive data
  encrypts :username
  encrypts :password
  encrypts :notes

  scope :search, ->(query) {
    where("title ILIKE ? OR website_url ILIKE ?", "%#{query}%", "%#{query}%")
  }

  def domain
    URI.parse(website_url).host rescue website_url
  end
end
