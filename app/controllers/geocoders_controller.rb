class GeocodersController < ApplicationController
  def lookup
    term = params[:term]
    result = Geocoder.search(term).map do |result|
      name = result.data['display_name']
      lat = result.data['lat']
      long = result.data['lon']
      {:label => name, :value => name, :data => {:lat => lat, :long => long}}
    end
    # Falls kein Ergebnis gefunden - Zeiger zum Kölner Dom, :label Termin + Hinweis, :value = Termin
    # LNG => 6.957437644009218
    # LAT => 50.9409528027427
    if(result.size == 0)
      result = [:label => "#{term} - (Keine OSM-Daten) ", :value => term, 
        :data => {:lat => 50.9409528027427, :long => 6.957437644009218}]
    end
    
    render :text => result.to_json
  end
end
