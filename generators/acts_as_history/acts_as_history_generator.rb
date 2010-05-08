class ActsAsHistoryGenerator < Rails::Generator::NamedBase
  attr_accessor :acts_as_history_table_name
  def initialize(runtime_args, runtime_options = {})
    self.acts_as_history_table_name = %w[:histories]
    
    runtime_args << 'create_acts_as_history' if runtime_args.empty?
    super
  end

  def manifest
    record do |m|
      m.migration_template 'acts_as_history_migration.rb', 'db/migrate'
    end
  end
end
