# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          not null, primary key
#  email                  :string
#  name                   :string
#  password_digest        :string
#  confirmation_token     :string
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmed_at           :datetime
#  password_restore_token :string
#  restore_token_sent_at  :datetime
#

class Account < ActiveRecord::Base
  has_secure_password
  before_create :generate_confirmation_token
  after_create :send_confirmation
  validates :email, uniqueness: true

  def confirm_email
    self.confirmation_sent_at = nil
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex
    # TODO: is it need to be _REALLY_ random?
    self.confirmation_sent_at = Time.now.utc
  end

  def send_confirmation
    AccountMailer.confirm_email(self).deliver
  end
end
