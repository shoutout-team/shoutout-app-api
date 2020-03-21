module Api
  class StaticController < ApplicationController
    def companies
      render_json(Static::COMPANIES)
    end
  end
end
