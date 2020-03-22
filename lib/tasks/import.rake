# rake import:cities
namespace :import do
  task cities: :environment do
    require 'csv'

    #data = CSV.parse(File.read(Rails.root.join('public/data/zuordnung_plz_ort.csv')), headers: true)

    file_path = Rails.root.join('public/data/zuordnung_plz_ort.csv')

    CSV.foreach(file_path, headers: true) do |row|
      Location.create!(name: row['ort'], postcode: row['plz'], federate_state: row['bundesland'], osm_id: row['osm_id'].to_i)
    end
  end
end
