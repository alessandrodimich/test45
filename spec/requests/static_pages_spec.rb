require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "-Home page:" do  # This test uses a shorter notation making use of the subject {page} above notation
		
		before {visit root_path}

		it {should have_content('Base Title of The Application')}
		it {should have_selector('title', :text => "Base Title of The Application")}
		it {should_not have_selector('title', :text => ' | Home')}

		describe "for signed-in users" do

			let(:user) { FactoryGirl.create(:user) }

			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it "should render the user' s feed" do
				user.feed.each do |item|
					page.should have_selector("li##{item.id}", text: item.content)
				end
			end	

		end
	
	end

	describe "-Help page:" do

		before {visit help_path	}

		it {should have_content('help')}
		it {should have_selector('h1', :text => "Help")}
		it {should have_selector('title', :text => "Base Title of The Application | Help")}
		
	end

	describe "About page" do

		before {visit about_path}

		it "should have the h1 'About Us'" do
			
			page.should have_selector('h1', :text => 'About Us')
		end
		
		it "should have the title 'About Us'" do
			
			page.should have_selector('title', :text => "Base Title of The Application | About Us")
		end 
	end

	describe "Contact page" do

		before {visit contact_path}
		
		it "should have the h1 'Contact'" do
			
			page.should have_selector('h1', text: 'Contact')
		end

		it "should have the title 'Contact'" do
			
			page.should have_selector('title',
				text: "Base Title of The Application | Contact")
		end
  end

end






