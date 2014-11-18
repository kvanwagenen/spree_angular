module SpreeAngular
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_angular'

    initializer "spree_angular.register.asset_paths" do |app|
      app.config.assets.paths << File.join(spree_angular_root, "lib", "assets","bower_components")
      app.config.assets.paths << File.join(spree_angular_root, "vendor", "assets", "bower_components")
    end

    initializer "spree_angular.static_assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, File.join(root, "public"))
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(spree_angular_root, 'app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    def spree_angular_root
      File.join(File.dirname(__FILE__), '../../')
    end

    config.to_prepare &method(:activate).to_proc
  end
end
