class Hall < ApplicationRecord
    has_many :shows, dependent: :destroy
    
    # validations
    validates :name, presence: true
    validates :capacity, presence: true, numericality: { greater_than: 0, only_integer: true }
end
