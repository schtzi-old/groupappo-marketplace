class Booking < ApplicationRecord
  belongs_to :user
  has_many :product_assignments, dependent: :destroy
  has_many :products, through: :product_assignments

  validates :start_date, :end_date, :booking_status, presence: true
  validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
  validates :start_date, comparison: { greater_than_or_equal_to: Date.today }

  enum :booking_status, { draft: 0, unconfirmed: 1, confirmed: 2, completed: 3, declined: 4 }, default: :draft

  def booking_days
    ((end_date - start_date) / 86_400).round(0)
  end

  def update_price
    price_per_day = 0
    products.each do |product|
      price_per_day += product.price
    end
    total = price_per_day * booking_days
    update(price: total)
  end
end
