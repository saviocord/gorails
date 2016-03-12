FactoryGirl.define do
  factory :user do
  	nickname 'MyNickName'
  	first_name 'MyFirstName'
  	last_name 'MyLastName'
  	cpf '54256315454'
  	email 'user@test.com'
  	password '12345678'
    password_confirmation '12345678'
  end
end