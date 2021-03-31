class Ticket < ApplicationRecord
       # validates :phonenumber, {presence: true,length: { is: 11 } }

   #has_many :posts

   validates :ticket_id, {presence: true, uniqueness: true}
   belongs_to :post

end
