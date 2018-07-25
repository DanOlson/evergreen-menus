class Payment < ActiveRecord::Base
  belongs_to :account
  monetize :price_cents

  enum status: { created: 0, succeeded: 1, pending: 2, failed: 3 }
end
