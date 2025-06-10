class User < ApplicationRecord
  has_secure_password

  has_many :password_entries, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :master_password_digest, presence: true

  # Generate JWT token
  def generate_jwt_token
    payload = {
      user_id: id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  # Decode JWT token
  def self.decode_jwt_token(token)
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
    User.find(decoded["user_id"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    nil
  end
end
