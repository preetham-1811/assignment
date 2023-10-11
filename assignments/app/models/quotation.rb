class Quotation < ApplicationRecord
	validates :author_name,presence: true
	validates :quote , presence: true, uniqueness: {case_sensitive: false}


  	def self.search(search)
    	if search
    		where('lower(quote) LIKE lower(?) OR lower(author_name) LIKE lower(?)', "%#{search}%", "%#{search}%")
    	else
      		all
    	end
  	end

end