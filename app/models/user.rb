class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :book
  has_many :book_comments, dependent: :destroy
  # foreign_key（FK）には、@user.xxxとした際に「@user.idがfollower_idなのかfollowed_idなのか」を指定します。
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # そのユーザがフォローしている人orフォローされている人の一覧を出したい
  has_many :following_users, through: :followers, source: :followed # 自分がフォローしている人
  has_many :follower_users, through: :followings, source: :follower # 自分をフォローしている人
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms
  has_many :view_counts, dependent: :destroy
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローしたときの処理
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  # フォローしていればtrueを返す
  def following?(user)
    following_users.include?(user)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end