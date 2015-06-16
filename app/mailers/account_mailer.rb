class AccountMailer < ApplicationMailer
  def confirm_email(account)
    @account = account
    mail(to: @account.email, subject: '[CENTRPRO] Вам необходимо подтвердить ваш электронный адрес')
  end

  def password_restore(account)
    @account = account
    mail(to: @account.email, subject: '[CENTRPRO] Инструкции для сброса пароля')
  end
end
