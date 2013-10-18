FactoryGirl.define do
  
  factory :user do
    sequence(:first_name)  { |n| "FirstName #{n}" }
    sequence(:last_name)  { |n| "LastName #{n}" }
    sequence(:nickname)  { |n| "nickame #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    
 	# With the following line we can now use FactoryGirl.create(:admin) 
 	#to create an administrative user in our tests.
    factory :admin do
    	admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end

end