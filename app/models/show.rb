class Show < ApplicationRecord
    belongs_to :hall
    has_many :reservations, dependent: :destroy

    # validations
    validates :name, presence: true, on: [:create, :update]
    validates :start_time, presence: true, uniqueness: { scope: :hall }, on: [:create, :update]
    validates :end_time, presence: true, on: [:create, :update]
    validate :end_time_is_after_start_time, on: [:create, :update]
    
    def total_available_seats
        hall[:capacity] - self.reserved_seats
    end

    def reserved_seats
        Rails.cache.fetch([self, :reserved_seats]) {
            reservations.sum(:total_seats) || 0
        }
    end

    def sold_out?
        self.total_available_seats == 0
    end

    def can_cancel?
        self.reserved_seats < 100
    end

    def can_confirm?
        self.reserved_seats > 100
    end

    private
        def end_time_is_after_start_time
            if start_time && end_time && end_time < start_time
                errors.add(:end_time, 'cannot be before the start time')
            end
        end

    # TODO: check for overlaps in timings
end
