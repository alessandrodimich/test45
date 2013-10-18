require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    
    let (:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do
      it { should have_selector('div.pagination') }
    end


    it "should list each user" do
      User.paginate(page: 1).each do |user|
        page.should have_selector('li', text: user.full_name)
      end
    end

    describe "delete links" do
      
      it { should_not have_link ('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin)}
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link ('delete'), href: user_path(User.first)  }
      
        it "should be able to delete another user" do
           expect { click_link('delete') }.to change(User, :count).by(-1)
        end    
        
        it { should_not have_link ('delete'), href: user_path(admin) }

      end
    end

  end




  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end


  describe "profile page" do
    let(:user) { FactoryGirl.create(:user)}  #let is used to create a local variable, whereas the symbol  :user passed to 
  											#factory girl has to be the same as in factories.rb.
    let!(:micropost1) { FactoryGirl.create(:micropost, user: user, content: "Foo")}
    let!(:micropost2) { FactoryGirl.create(:micropost, user: user, content: "Bar")}                    
    
    before { visit user_path(user) } # Va a visitare lo user_path

    it { should have_selector('h1',    text: user.full_name) }
    it { should have_selector('title', text: user.full_name) }

    describe "microposts" do
      it { should have_content(micropost1.content) }
      it { should have_content(user.microposts.count) }

    end

  end

  describe "signup" do

    before {visit signup_path}

    let(:submit) {"Create my account"}
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "After submission" do
        before {click_button submit}
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content('Password digest')}
      end
    end

    describe "with valid information" do

      before do
        fill_in "user_first_name",   with: "Example"
        fill_in "user_last_name",    with: "User"
        fill_in "user_nickname",     with: "foobarf"
        fill_in "user_email",        with: "user@example.com"
        fill_in "user_password",     with: "foobar2"
        fill_in "user_password_confirmation", with: "foobar2"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    
    describe "After saving a user" do
    
      before { click_button submit }

      let(:user) {User.find_by_email("user@example.com")}

      it { should have_selector('title', text: user.full_name) }

    end
  end
end
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    before { visit edit_user_path(user) }
    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
    describe "with invalid information" do
      before {click_button "Save changes" }
      it {should have_content('error')}
    end

    describe "with valid information" do  
       let(:new_first_name) {"New First Name"}
       let(:new_last_name) {"New Last Name"} 
       let(:new_email) {"newest@example.com"}
       before do
        fill_in "user_first_name", with: new_first_name
        fill_in "user_last_name", with:  new_last_name
        fill_in "user_email", with: new_email
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password 
        click_button "Save changes"  
       end
      it { should have_selector('title', text: new_first_name) }
      it { should have_selector('title', text: new_last_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.first_name.should  == new_first_name }
      specify { user.reload.last_name.should  == new_last_name }
      specify { user.reload.email.should == new_email }      
    end
  

  
#End of tests
end




end