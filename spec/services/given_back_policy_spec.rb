require "rails_helper"

RSpec.describe GivenBackPolicy, type: :service do
  let(:user) { double }
  let(:book) { double }
  subject { described_class.new(user: user, book: book) }

  describe '#applies?' do
    before {
      allow(book).to receive_message_chain(:reservations, :find_by).with(no_args).
        with(user: user, status: 'TAKEN').and_return(reservation)
    }
    context 'does apply' do
      let(:reservation) {double}
      it {
        expect(subject.applies?).to be_truthy
      }
    end

    context 'does not apply' do
      let(:reservation) {nil}
      it {
        expect(subject.applies?).to be_falsey
      }
    end

  end
end
