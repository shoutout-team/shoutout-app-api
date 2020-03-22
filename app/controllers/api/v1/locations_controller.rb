module Api
  module V1
    class LocationsController < Api::BaseController
      def search
        term = params[:term].strip.downcase
        city = term.delete('^a-zA-Z')
        postcode = term.scan(/\d+/).first

        @locations = Location.where('lower(name) LIKE ?', "%#{city}%").where('postcode LIKE ?', "%#{postcode}%")
        render_json(@locations)
      end

      def cities
        term = params[:term].strip.downcase
        city = term.delete('^a-zA-Z')

        @locations = Location.where('lower(name) LIKE ?', "%#{city}%").pluck(:name).uniq.sort
        render_json(@locations)
      end
    end
  end
end
