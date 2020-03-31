module Api
  module V1
    class StateController < Api::BaseController
      def ping
        render_json(alive: true)
      end
    end
  end
end
