class BookNotifierMailer < ApplicationMailer
  include ApplicationHelper

  default from: 'warsztaty@infakt.pl'
  layout 'mailer'
  def time_to_give_back_the_book(book)
    @book = book
    @reservation = book.reservations.find_by_status("TAKEN")
    @borrower = @reservation.user

    mail(to: @borrower.email, subject: "Czas oddać książkę #{book.title}")
  end

  def reserved_book_available(book)
    @book = book
    @reservation = book.reservations.find_by(status: "TAKEN")
    @reserver = book.reservations.find_by(status: "RESERVED").try(:user)
    
    mail(to: @reserver.email, subject: "Książka #{@book.title} wkrótce dostępna!") if @reserver
  end
end
