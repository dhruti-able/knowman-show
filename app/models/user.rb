class User < ApplicationRecord
  has_secure_password

  has_many :reservations, dependent: :destroy
  
  # validations
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }

end
