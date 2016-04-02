class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = 'http://simcentered.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome to SimCentered')
  end
end
