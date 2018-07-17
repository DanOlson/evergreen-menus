require 'stripe'

class PlanCreator
  attr_reader :remote_id, :name, :price_cents, :interval, :trial_period_days, :product_id

  def initialize(remote_id:, name:, price_cents:, product_id:, interval: 'month', trial_period_days: 21)
    @remote_id = remote_id
    @name = name
    @price_cents = price_cents
    @interval = interval
    @trial_period_days = trial_period_days
    @product_id = product_id
  end

  def call
    stripe_plan = Stripe::Plan.create({
      id: remote_id,
      nickname: name,
      amount: price_cents,
      currency: 'usd',
      interval: interval,
      product: product_id,
      trial_period_days: trial_period_days
    })
    Plan.create({
      remote_id: stripe_plan.id,
      name: name,
      price_cents: price_cents,
      interval: interval,
      interval_count: 1,
      status: :active
    })
  rescue => e
    puts "Failed to create plan: #{e.message}\n#{e.backtrace.join("\n")}"
  end
end

namespace :stripe do
  task create_plans: :environment do
    products = Stripe::Product.list
    product = products.find { |p| p.name == 'Evergreen Menus' }

    product ||= Stripe::Product.create({
      name: 'Evergreen Menus',
      type: 'service'
    })

    plans = [
      {
        remote_id: "one-and-done-#{Rails.env}",
        name: 'One and Done',
        price_cents: 3900,
        product_id: product.id
      },
      {
        remote_id: "restauranteur-#{Rails.env}",
        name: 'Restauranteur',
        price_cents: 7900,
        product_id: product.id
      },
      {
        remote_id: "franchisee-#{Rails.env}",
        name: 'Franchisee',
        price_cents: 17900,
        product_id: product.id
      }
    ]

    plans.each do |plan|
      puts "Creating #{plan[:name]}"
      PlanCreator.new(**plan).call
    end
  end
end
