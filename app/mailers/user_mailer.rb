class UserMailer < ApplicationMailer
  include ApplicationHelper

  default from: 'warsztaty@infakt.pl'
  layout 'mailer'

  def book_taken_confirmation(user, book)
    @book = book
    @user = user
    mail(to: user.email, subject: "Potwierdzenie wypożycznia #{book.title}")
  end
end
