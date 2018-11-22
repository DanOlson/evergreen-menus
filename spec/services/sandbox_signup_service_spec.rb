require 'spec_helper'

describe SandboxSignupService, :vcr do
  describe '#call' do
    let(:instance) { SandboxSignupService.new 'dude@lebowski.me' }

    before do
      create :plan, :tier_1
    end

    it 'creates an account' do
      expect {
        instance.call
      }.to change(Account, :count).by 1
    end

    it 'creates a subscription' do
      expect {
        instance.call
      }.to change(Subscription, :count).by 1
    end

    it 'creates a user' do
      expect {
        instance.call
      }.to change(User, :count).by 1
      expect(instance.user).to be_a User
      expect(instance.user.email).to eq 'dude@lebowski.me'
    end

    context 'when the given email address belongs to an existing user' do
      let(:email) { 'walter@lebowski.me' }
      let(:instance) { SandboxSignupService.new email }

      before do
        create :user, email: email
      end

      it 'raises an exception' do
        expect {
          instance.call
        }.to raise_error(SandboxSignupService::EmailTakenError)
      end

      it 'does not create a customer in Stripe' do
        stripe_request = a_request(:post, 'https://api.stripe.com/v1/customers')
        instance.call rescue nil
        expect(stripe_request).not_to have_been_made
      end

      it 'does not create an Account' do
        expect {
          instance.call rescue nil
        }.to_not change(Account, :count)
      end

      it 'does not create a Subscription' do
        expect {
          instance.call rescue nil
        }.to_not change(Subscription, :count)
      end

      it 'does not create a User' do
        expect {
          instance.call rescue nil
        }.to_not change(User, :count)
      end
    end
  end
end
