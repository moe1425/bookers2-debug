class Room < ApplicationRecord

  has_many :chats
  #1つのルームにいるユーザ数は2人のためhas_manyになる
  has_many :user_rooms

end