class GeocodersController < ApplicationController
  def lookup
    term = params[:term]
    result = Geocoder.search(term).map do |result|
      name = result.data['display_name']
      lat = result.data['lat']
      long = result.data['lon']
      {:label => name, :value => name, :data => {:lat => lat, :long => long}}
    end
    render :text => result.to_json
  end
end
