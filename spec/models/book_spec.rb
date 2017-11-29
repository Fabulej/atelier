require "rails_helper"

RSpec.describe Book, type: :model do
  subject { described_class.new }
  let(:user) { User.new }

  describe '#can_give_back' do
    context 'without any reservations' do
      it {
        expect(subject.can_be_given_back?(user)).to be_falsey
      }
    end
    context 'with reservation' do
      let(:reservation) { double }
    before {
      allow(subject).to receive_message_chain(:reservations, :find_by).with(no_args).
        with(user: user, status: 'TAKEN').and_return(reservation)
    }
    it {
      expect(subject.can_be_given_back?(user)).to be_truthy
    }
    end
  end
end
