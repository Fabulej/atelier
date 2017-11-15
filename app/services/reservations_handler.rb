class ReservationsHandler
  def initialize(user)
    @user = user
  end

  def take(book)
    return "Books is not available for reservation" unless book.can_be_taken?(user)
    if book.available_reservation.present?
      send_mailers(available_reservation)
      book.available_reservation.update_attributes(status: 'TAKEN')
      UserMailer.book_taken_confirmation(user, book).deliver_now
    else
      book.reservations.create(user: user, status: 'TAKEN')
      send_mailers(reservations.create(user: user, status: 'TAKEN'))
      UserMailer.book_taken_confirmation(user, book).deliver_now
    end
  end

  def give_back(book)
    ActiveRecord::Base.transaction do
      book.reservations.find_by(status: 'TAKEN').update_attributes(status: 'RETURNED')
      book.next_in_queue.update_attributes(status: 'AVAILABLE') if next_in_queue(book).present?
    end
  end

  def reserve(book)
    return unless book.can_reserve?(user)
    book.reservations.create(user: user, status: 'RESERVED')

  end

  def cancel_reservation(book)
    book.reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end


  private
  attr_reader :user


  def next_in_queue(book)
    book.reservations.where(status: 'RESERVED').order(created_at: :asc).first
  end

  def send_mailers(res)
    remind_date = res.expires_at - 1.day
    ::BookNotifierMailer.delay(run_at: remind_date).book_return_remind(res.book)
    ::BookNotifierMailer.delay(run_at: remind_date).book_reserved_return(res.book)
  end
end
