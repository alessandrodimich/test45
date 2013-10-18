# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  nickname   :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  full_name  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :nickname, :full_name, :password, :password_confirmation
  
  has_secure_password  

  has_many :microposts, dependent: :destroy




  before_save { |user| user.full_name = "#{user.first_name} #{user.last_name}"}
  before_save { |user| user.email = email.downcase}  #this block passed to the before_save callback ensures 
  													 #the the email is downcase before saving to database
  before_save :create_remember_token

  validates(:first_name, presence: true, length: { maximum: 50 })
  validates(:last_name, presence: true, length: { maximum: 50 })
  validates(:nickname, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false})
  validates(:password, length: { minimum: 6 })
  validates(:password_confirmation, presence: true)

  def feed
  # This is preliminary. See "Following users" for the full implementation.
  
  # self.microposts --- ALTERNATIVE 1
  # microposts  --- ALTERNATIVE 2 (self in this case is not necessary)
  Micropost.where("user_id = ?", id) # --- ALTERNATIVE 3 (the question mark is used in order to avoid SQL injection attacks)
  
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
  
end
		
