class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.all.distinct.pluck(:rating)
    end
end
