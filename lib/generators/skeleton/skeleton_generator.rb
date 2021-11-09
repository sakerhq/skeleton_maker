class SkeletonGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  include Rails::Generators::ResourceHelpers
  
  namespace "skeleton"
  
  argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
  attr_accessor :attributes

  class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"
  
  class_option :api_version, type: :string, default: 1, desc: "api version number"

  source_root File.expand_path('../templates', __FILE__)

  def create_model_migration_files
    migration_template "migration.rb", File.join("db/migrate", "create_#{table_name}.rb"), migration_version: migration_version
  end

  def create_model_files
    template 'model.rb', File.join("app/models", "#{file_name}.rb")
  end

  def create_factory_file
    template "factory.rb", File.join("spec/factories", "#{plural_file_name}.rb")
  end

  def create_model_spec_files
    template "model_spec.rb", File.join("spec/models", "#{file_name}_spec.rb")
  end

  def create_controller_files
    template "controller.rb", File.join("app/controllers/api", prefix, "#{controller_file_name}_controller.rb")
  end

  def create_policy_file
    template "policy.rb", File.join("app/policies", "#{file_name}_policy.rb")
  end

  def create_form_file
    template "form.rb", File.join("app/forms", "#{file_name}_form.rb")
  end

  def create_request_spec_files
    template "request_spec.rb", File.join("spec/requests/api", prefix, "#{file_name}_spec.rb")
  end

  def add_resource_route
    route "resources :#{file_name.pluralize}, only: %i[index show create update destroy]", namespace: ["api", prefix]
  end

  def create_view_files
    template "views/_resource.json.jbuilder", File.join("app/views/api", prefix, plural_name, "_#{file_name}.json.jbuilder")
    %w(index show create update).each do |name|
      template "views/#{name}.json.jbuilder", File.join("app/views/api", prefix, plural_name, "#{name}.json.jbuilder")
    end
  end

  def create_seed_files
    template "seed.rb", File.join("db/seeds", "#{plural_file_name}.rb")
  end
  
  private

    def rails5_and_up?
      Rails::VERSION::MAJOR >= 5
    end

    def rails61_and_up?
      Rails::VERSION::MAJOR > 6 || (Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR >= 1)
    end

    def migration_version
      if rails5_and_up?
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end

    def prefix
      "v#{options[:api_version]}"
    end

    def prefixed_controller_class_name
      "Api::#{prefix.capitalize}::#{controller_class_name}"
    end

    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end

    def primary_key_type
      primary_key_string if rails5_and_up?
    end

    def primary_key_string
      key_string = options[:primary_key_type]
      ", id: :#{key_string}" if key_string
    end

end