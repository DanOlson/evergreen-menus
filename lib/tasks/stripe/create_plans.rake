require 'stripe'

class PlanCreator
  attr_reader :remote_id,
              :name,
              :price_cents,
              :interval,
              :trial_period_days,
              :product_id,
              :description

  def initialize(remote_id:,
                 name:,
                 price_cents:,
                 product_id:,
                 interval: 'month',
                 trial_period_days: 14,
                 description: nil)
    @remote_id = remote_id
    @name = name
    @price_cents = price_cents
    @interval = interval
    @trial_period_days = trial_period_days
    @product_id = product_id
    @description = description
  end

  def call
    # stripe_plan = Stripe::Plan.create({
    #   id: remote_id,
    #   nickname: name,
    #   amount: price_cents,
    #   currency: 'usd',
    #   interval: interval,
    #   product: product_id,
    #   usage_type: 'licensed',
    #   trial_period_days: trial_period_days
    # })
    Plan.create({
      remote_id: remote_id,
      name: name,
      price_cents: price_cents,
      interval: interval,
      interval_count: 1,
      status: :active,
      description: description
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
        remote_id: "t1-#{Rails.env}",
        name: 'The Snack',
        price_cents: 3000,
        product_id: product.id,
        description: 'Basic, in-house functions like print menus, digital displays, and website integration'
      },
      {
        remote_id: "t2-#{Rails.env}",
        name: 'The Meal',
        price_cents: 5000,
        product_id: product.id,
        description: 'Print menus, digital displays, website integration, Google My Business, and social media integrations'
      },
      {
        remote_id: "t3-#{Rails.env}",
        name: 'The Feast',
        price_cents: 7500,
        product_id: product.id,
        description: 'All features, plus white glove setup and premium support'
      }
    ]

    plans.each do |plan|
      puts "Creating #{plan[:name]}"
      PlanCreator.new(**plan).call
    end
  end
end
