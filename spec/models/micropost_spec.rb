require 'spec_helper'
describe "Micropost Model Tests:" do
	let(:user) { FactoryGirl.create(:user) }
	
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  
  	subject { @micropost }
  	
  	it { should respond_to(:content) }  # it indicates that it should have a content
  	it { should respond_to(:user_id) }  # it indicates that it should have a user_id
  	it { should respond_to(:user) }  # it indicates that it should have a user
  	its(:user) { should == user }

  	it { should be_valid }

  	describe "When user id is not present" do
  		before { @micropost.user_id = nil }
  		it { should_not be_valid }
  	end

    describe "with blank content" do
      before { @micropost.content = " " }
      it { should_not be_valid }
    end

    describe "with content that is too long" do
      before { @micropost.content = "a" * 145 }
      it { should_not be_valid }
    end

  	describe "accessible attributes" do
  		# This test verifies that calling Micropost.new with a nonempty 
  		# user_id raises a mass assignment security error exception
  		it "should not allow access to user_id" do
  			expect do
  				Micropost.new(user_id: user.id)
  			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  		end 
  	end

end