class Ticket < ApplicationRecord
       # validates :phonenumber, {presence: true,length: { is: 11 } }

   #has_many :posts
   belongs_to :post

   validates :ticket_id, {presence: true, uniqueness: true}

end
