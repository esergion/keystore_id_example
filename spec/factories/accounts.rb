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

FactoryGirl.define do
  factory :account do
    email "MyString"
name "MyString"
encrypted_password "MyString"
confirmation_token ""
confirmation_sent_at "2015-05-26 16:23:53"
  end

end
