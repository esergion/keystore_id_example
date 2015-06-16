class RegistrationController < ApplicationController
  include CASino::SessionsHelper
  include CASino::AuthenticationProcessor
  include CASino::TwoFactorAuthenticatorProcessor
  before_filter :redirect_signed_in_users, only: [:create, :new]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      flash[:notice] = 'Подтвердите ваш адрес электронной почты'
      redirect_to login_path
    else
      flash[:error] = 'Ошибка, попробуйте еще раз или свяжитесь с нами'
      redirect_to main_app.registration_new_path
    end
  end

  def update
    @account = Account.find_by(email: account_params[:email])
    if @account && (@account.password_restore_token == account_params[:password_restore_token])
      @account.update_attribute :password, account_params[:password]
      @account.update_attribute :password_restore_token, nil
      @account.update_attribute :restore_token_sent_at, nil
      flash[:success] = 'Пароль изменен, пожалуйста, воспользуйтесь формой входа'
      redirect_to login_path
    else
      flash[:error] = 'Что-то пошло не так.. Видимо что-то случилось'
      redirect_to main_app.registration_new_path
    end
  end

  def email_confirmation
    @account = Account.find_by(confirmation_token: params[:token])
    if @account
      @account.confirm_email
      flash[:success] = 'Адрес подтвержден, пожалуйста, войдите используя ваши логин и пароль.'
      redirect_to login_path
    else
      flash[:error] = 'Пользователя с таким адресом не существует'
      redirect_to main_app.registration_new_path
    end
  end

  def forgot_pass
  end

  def send_pass_token
    @account = Account.find_by(email: params[:send][:email])
    if @account
      send_password_restoration_token(@account)
      flash[:success] = 'Инструкции для сброса пароля были отправлены на ваш адрес'
      redirect_to login_path
    else
      flash[:error] = 'Пользователь не найден'
      redirect_to main_app.registration_new_path
    end
  end

  def restore_pass
    @account = Account.find_by(password_restore_token: params[:token])
    if @account
      render 'restore_pass'
    else
      flash[:error] = 'Пользователь не найден'
      redirect_to main_app.registration_new_path
    end
  end

  def new_confirmation
  end

  def resend_confirmation
    @account = Account.find_by(email: params[:resend][:email])
    if @account && @account.confirmed_at.nil?
      @account.generate_confirmation_token
      @account.save
      @account.send_confirmation
      flash[:success] = 'Инструкции по активации были отправлены заново'
      redirect_to login_path
    elsif !@account.confirmed_at.nil?
      flash[:error] = 'Адрес подтвержден, войдите используя ваши логин и пароль'
      redirect_to login_path
    else
      flash[:error] = 'Пользователь не найден'
      redirect_to main_app.registration_new_path
    end
  end

  private

  def redirect_signed_in_users
    redirect_to casino.sessions_path if signed_in?
  end

  def account_params
    params.require(:account).permit(:email, :name, :password,
                                    :password_confirmation, :password_restore_token)
  end

  def send_password_restoration_token(resource)
    resource.password_restore_token = SecureRandom.hex
    resource.restore_token_sent_at = Time.now.utc
    resource.save
    AccountMailer.password_restore(resource).deliver
  end
end
