# frozen_string_literal: true

# This file overrides Rails methods such that we can test without installing
# multiple versions of Rails in the test suite. If different versions of Rails
# begin treating route generation differently, new overrides should be written
# for each version.
#
# The mocks used should reflect the files located in `test/mock/app/`.
module Rails
  def self.application
    routes = []

    # Mock tacos#create route.
    taco_create = Minitest::Mock.new
    taco_create.expect(:defaults, controller: 'api/tacos', action: 'create')
    taco_create.expect(:verb, 'POST')
    taco_create_path = Minitest::Mock.new
    taco_create_path.expect(:spec, '/api/tacos(.:format)')
    taco_create.expect(:path, taco_create_path)
    taco_create.expect(:name, 'api_taco')
    routes.push(taco_create)

    # Mock tacos#update route.
    taco_update = Minitest::Mock.new
    taco_update.expect(:defaults, controller: 'api/tacos', action: 'update')
    taco_update.expect(:verb, 'PUT')
    taco_update_path = Minitest::Mock.new
    taco_update_path.expect(:spec, '/api/tacos/:id(.:format)')
    taco_update.expect(:path, taco_update_path)
    taco_update.expect(:name, 'api_tacos')
    routes.push(taco_update)

    # Mock waterlilies#show route.
    wl_show = Minitest::Mock.new
    wl_show.expect(:defaults, controller: 'waterlilies', action: 'show')
    wl_show.expect(:verb, 'GET')
    wl_show_path = Minitest::Mock.new
    wl_show_path.expect(:spec, '/waterlilies/:id(.:format)')
    wl_show.expect(:path, wl_show_path)
    wl_show.expect(:name, 'waterlilies')
    routes.push(wl_show)

    # Mock Rails methods.
    app = Minitest::Mock.new
    app_routes = Minitest::Mock.new
    app_routes.expect(:routes, routes)
    app.expect(:routes, app_routes)
    app
  end

  def self.root
    rails_root = Minitest::Mock.new
    rails_root.expect \
      :join,
      'test/mock/app/controllers/**/*_controller.rb', [String]
    rails_root
  end
end