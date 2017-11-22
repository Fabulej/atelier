namespace :reservation do
  desc "Remind users to give back the book"
  task send_remind_mailers: :environment do
    reservations = Reservation.where(status: "TAKEN").where("expires_at = ?",  Time.now+1.day)
    reservations.each do |reservation|
      ::BookNotifierMailer.time_to_give_back_the_book(reservation.book).deliver_now
      ::BookNotifierMailer.reserved_book_available(reservation.book).deliver_now
    end
  end
end
