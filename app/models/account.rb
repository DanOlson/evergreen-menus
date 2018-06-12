class Account < ActiveRecord::Base
  validates :name, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :google_my_business_account_id, uniqueness: true, allow_nil: true
  validate :establishments_have_unique_facebook_pages, on: [:update]
  has_many :users
  has_many :establishments
  has_many :user_invitations
  accepts_nested_attributes_for :establishments

  def google_my_business_enabled?
    AuthToken.google.for_account(self).exists?
  end

  def facebook_enabled?
    AuthToken.facebook_user.for_account(self).exists?
  end

  private

  def establishments_have_unique_facebook_pages
    counts_by_fb_page_id = establishments.inject({}) do |acc, est|
      page_id = est.facebook_page_id
      if page_id.present?
        count = acc.fetch(page_id, 0)
        acc[page_id] = count + 1
        acc
      else
        acc
      end
    end

    ###
    # Kind of a hacky way of validating the Facebook page associations
    # that relies on the same sort order as displayed on the form in order
    # to relay which establishments had uniqueness issues.
    establishments.sort_by(&:name).each_with_index do |est, idx|
      if counts_by_fb_page_id.fetch(est.facebook_page_id, 0) > 1
        errors.add(:"establishments[#{idx}].facebook_page_id", 'has already been taken')
      end
    end
  end
end
