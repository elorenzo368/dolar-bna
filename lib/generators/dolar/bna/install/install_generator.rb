require 'rails'
require 'rails/generators'
require 'rails/generators/migration'
module Dolar
  module Bna
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        include Rails::Generators::Migration
        source_root File.expand_path('../templates', __FILE__)
        desc "Add the migrations for DoubleDouble"

        def self.next_migration_number(path)
          next_migration_number = current_migration_number(path) + 1
          ActiveRecord::Migration.next_migration_number(next_migration_number)
        end

        def copy_migrations
          if !ActiveRecord::Base.table_exists?("dolar_cotizations")
            migration_template "create_dolar_cotizations.rb",
              "db/migrate/create_dolar_cotizations.rb"
          end
        end

      end
    end
  end
end
