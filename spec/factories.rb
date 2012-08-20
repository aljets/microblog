FactoryGirl.define do
  factory :user do
    name      "Clark Kent"
    email     "clarkk@dailyplanet.com"
    password  "kryptonite"
    password_confirmation "kryptonite"
  end
end
