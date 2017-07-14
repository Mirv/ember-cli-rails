module EmberCli
  class HerokuGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    namespace "ember:heroku"

    def copy_package_json_file
      template "package.json.erb", "package.json"
    end

    def identify_as_yarn_project
      if EmberCli.any?(&:yarn_enabled?)
        template "yarn.lock.erb", "yarn.lock"
      end
    end

    def inject_12factor_gem
      gem "rails_12factor", group: [:staging, :production]
    end

    private

    def cache_directories
      all_cachable_directories.map do |cacheable_directory|
        cacheable_directory.relative_path_from(Rails.root).to_s
      end
    end

    def all_cachable_directories
      [
        apps.flat_map(&:cacheable_directories),
        Rails.root.join("node_modules"),
      ].flatten
    end

    def app_paths
      EmberCli.apps.values.map do |app|
        app.root_path.relative_path_from(Rails.root)
      end
    end

    def apps
      EmberCli.apps.values
    end
  end
end
