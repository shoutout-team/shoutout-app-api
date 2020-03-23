unless User.any?
  User.create!(email: 'michael.ajwani@i22.de', name: 'Micha', password: 'Development123!', role: :developer, approved: true, confirmed_at: Time.zone.today)
  User.create!(email: 'leo.reuter@i22.de', name: 'Leo', password: 'Development123!', role: :developer, approved: true, confirmed_at: Time.zone.today)
  User.create!(email: 'henry.steinhauer@i22.de', name: 'Henry', password: 'Development123!', role: :developer, approved: true, confirmed_at: Time.zone.today)
  User.create!(email: 'dominik.criado@i22.de', name: 'Dominik', password: 'Development123!', role: :administrator, approved: true, confirmed_at: Time.zone.today)
  User.create!(email: 'lena.overkamp@i22.de', name: 'Lena', password: 'Development123!', role: :administrator, approved: true, confirmed_at: Time.zone.today)
  User.create!(email: 'jessica.willius@i22.de', name: 'Jessi', password: 'Development123!', role: :administrator, approved: true, confirmed_at: Time.zone.today)
end

unless User.keepers.any? && Company.any?
  begin
    @k01 = User.create!(email: 'jana.roettgen@zyx-mail.de', name: 'Jana Röttgen', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k02 = User.create!(email: 'marco.martins@zyx-mail.de', name: 'Marco Martins', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k03 = User.create!(email: 'tobias.mintert@zyx-mail.de', name: 'Tobias Mintert', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k04 = User.create!(email: 'ivana.louis@zyx-mail.de', name: 'Ivana Louis', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k05 = User.create!(email: 'nikos.kasapidis@zyx-mail.de', name: 'Nikos Kasapidis', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k06 = User.create!(email: 'stephanie.eckert@zyx-mail.de', name: 'Stephanie Eckert', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k07 = User.create!(email: 'eddy.mustermann@zyx-mail.de', name: 'Eddy Mustermann', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k08 = User.create!(email: 'denise.dunker@zyx-mail.de', name: 'Denise Dunker', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k09 = User.create!(email: 'brigitte@zyx-mail.de', name: 'Brigitte', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k10 = User.create!(email: 'björn@zyx-mail.de', name: 'Björn', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k11 = User.create!(email: 'marcel.michels@zyx-mail.de', name: 'Marcel Michels', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k12 = User.create!(email: 'jon.doe1@zyx-mail.de', name: 'Jon Doe 1', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k13 = User.create!(email: 'jon.doe2@zyx-mail.de', name: 'Jon Doe 2', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k14 = User.create!(email: 'jon.doe3@zyx-mail.de', name: 'Jon Doe 3', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)
    @k15 = User.create!(email: 'jon.doe4@zyx-mail.de', name: 'Jon Doe 4', password: 'Keeper123!', role: :user, approved: true, confirmed_at: Time.zone.today)

    properties = {
      description: 'A really nice description about the company',
      cr_number: '123456-ABC-7890',
      notes: 'A personal note to anyone who donates',
      payment: {
        paypal: 'https://paypal.me/my-company-name',
        gofoundme: 'https://gofoundme.com/my-company-name',
        ticket_io: 'https://ticket.io/my-company-name',
        bank: { holder: nil, iban: nil }
      },
      links: {
        website: 'https://my-company-name.de',
        facebook: 'https://facebook.com/my-company-name',
        twitter: 'https://twitter.com/my-company-name',
        instagram: 'https://instagram.com/my-company-name'
      }
    }

    Company.create!(name: 'Café Frida', category: :cafe, user: @k01, street: 'Bornheimer Straße', street_number: '57', postcode: '53119', city: 'Bonn', latitude: 50.737273, longitude: 7.085851, properties: properties)
    Company.create!(name: 'Zum scheuen Reh', category: :bar, user: @k02, street: 'Hans-Böckler-Platz', street_number: '2', postcode: '50672', city: 'Köln', latitude: 50.943762, longitude: 6.933824, properties: properties)
    Company.create!(name: 'Barracuda-Bar', category: :bar, user: @k03, street: 'Bismarckstraße', street_number: '44', postcode: '50672', city: 'Köln', latitude: 50.941464, longitude: 6.935182, properties: properties)
    Company.create!(name: 'Veedelskrämer', category: :shop, user: @k04, street: 'Körner Straße', street_number: '2-4', postcode: '50823', city: 'Köln', latitude: 50.948069, longitude: 6.921838, properties: properties)
    Company.create!(name: 'Nikos Friseure', category: :coiffeur,  user: @k05, street: 'Belderberg', street_number: '19', postcode: '53113', city: 'Bonn', latitude: 50.735880, longitude: 7.105141, properties: properties)
    Company.create!(name: 'Café Nale Café', category: :cafe, user: @k06, street: 'Darmstädter Straße', street_number: '19', postcode: '50678', city: 'Köln', latitude: 50.919261, longitude: 6.961764, properties: properties)
    Company.create!(name: 'Eddys Haarkultur', category: :coiffeur, user: @k07, street: 'Bonner Straße', street_number: '49', postcode: '50667', city: 'Köln', latitude: 50.917814, longitude: 6.960779, properties: properties)
    Company.create!(name: 'Miss Minz - Das B', category: :kiosk, user: @k08, street: 'Rheinaustraße', street_number: '101', postcode: '53225', city: 'Bonn', latitude: 50.740102, longitude: 7.113713, properties: properties)
    Company.create!(name: 'Brigittes Büdchen', category: :kiosk, user: @k09, street: 'Merowingerstraße', street_number: '73', postcode: '50677', city: 'Köln', latitude: 50.919928, longitude: 6.954558, properties: properties)
    Company.create!(name: 'Björns Büdchen', category: :kiosk, user: @k10, street: 'Lülsdorfer Straße', street_number: '117', postcode: '51143', city: 'Köln', latitude: 50.846255, longitude: 7.004519, properties: properties)
    Company.create!(name: 'Friseur Michels', category: :coiffeur, user: @k11, street: 'Acherstraße', street_number: '30', postcode: '53111', city: 'Bonn', latitude: 50.735383, longitude: 7.099942117, properties: properties)
    Company.create!(name: 'Mayras Wohnzimm Café', category: :cafe, user: @k12, street: 'Friedrich-Breuer-Straße', street_number: '39', postcode: '53225', city: 'Bonn', latitude: 50.738746, longitude: 7.117492, properties: properties)
    Company.create!(name: 'Kiosk', category: :kiosk, user: @k13, street: 'Breite Straße', street_number: '17', postcode: '53111', city: 'Bonn', latitude: 50.737450, longitude: 7.095750, properties: properties)
    Company.create!(name: 'Frittebud Food', category: :food, user: @k14, street: 'Franzstraße', street_number: '42', postcode: '53111', city: 'Bonn', latitude: 50.736468, longitude: 7.093573, properties: properties)
    Company.create!(name: 'Untergrund Club', category: :club, user: @k15, street: 'Kesselgasse', street_number: '1', postcode: '53111', city: 'Bonn', latitude: 50.736912, longitude: 7.099255, properties: properties)
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed record #{e.record}"
    raise e
  end
end

# Disabled due to row-limit on heroku #20
# unless Location.any?
#   require 'csv'

#   file_path = Rails.root.join('public/data/zuordnung_plz_ort.csv')

#   CSV.foreach(file_path, headers: true) do |row|
#     Location.create!(name: row['ort'], postcode: row['plz'], federate_state: row['bundesland'], osm_id: row['osm_id'].to_i)
#   end
# end
