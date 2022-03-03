class Reservation < ApplicationRecord
    belongs_to :show, touch: true
    belongs_to :user

    #validations
    validates :total_seats, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10, only_integer: true }, on: :create
    validate :total_seats_is_less_than_available_seats, on: :create

    private
        def total_seats_is_less_than_available_seats
            if total_seats > show.total_available_seats
                errors.add(:total_seats, 'cannot be greater than available seats')
            end
        end
end
