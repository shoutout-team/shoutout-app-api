module Static
  # TODO: Move to App::Definitions #6
  CATEGORIES = {
    kiosk: 'Kiosk',
    bar: 'Bar',
    club: 'Club',
    cafe: 'Café',
    food: 'Food',
    coiffeur: 'Friseur',
    shop: 'Geschäft'
  }.freeze

  CATEGORIES_ENUM = { kiosk: 0, bar: 1, club: 2, cafe: 3, food: 4, coiffeur: 5, shop: 6 }.freeze

  COMPANIES = [
    {
      id: 1,
      name: 'Café Frida',
      title: 'Café Frida',
      category: 'Cafe',
      description: 'Dies ist eine Beispielbeschreibung',
      image: 'https://bildlink.bla',
      payments: {
        paypal: 'https://paypal.me/leoreuter',
        goFundMe: 'https://gofundme.com'
      },
      location: {
        latitude: 123,
        longitude: 123
      },
      properties: {}
    },
    {
      id: 2,
      name: 'Zum scheuen Reh',
      title: 'Zum scheuen Reh',
      category: 'Bar',
      description: 'Dies ist eine Beispielbeschreibung',
      image: 'https://bildlink.bla',
      payments: {
        paypal: 'https://paypal.me/leoreuter',
        goFundMe: 'https://gofundme.com'
      },
      location: {
        latitude: 123,
        longitude: 123
      },
      properties: {}
    },
    {
      id: 3,
      name: 'Barracuda Bar',
      title: 'Barracuda Bar',
      category: 'Bar',
      description: 'Dies ist eine Beispielbeschreibung',
      image: 'https://bildlink.bla',
      payments: {
        paypal: 'https://paypal.me/leoreuter',
        goFundMe: 'https://gofundme.com'
      },
      location: {
        latitude: 123,
        longitude: 123
      },
      properties: {}
    },
    {
      id: 4,
      name: 'Veedelskrämer',
      title: 'Veedelskrämer Feinkost & Bio-Produkte',
      category: 'Geschäft',
      description: 'Dies ist eine Beispielbeschreibung',
      image: 'https://bildlink.bla',
      payments: {
        paypal: 'https://paypal.me/leoreuter',
        goFundMe: 'https://gofundme.com'
      },
      location: {
        latitude: 123,
        longitude: 123
      },
      properties: {}
    }
  ].freeze
end
