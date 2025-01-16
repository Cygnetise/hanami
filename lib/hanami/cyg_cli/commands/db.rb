module Hanami
  # Hanami CygCLI
  #
  # @since 1.1.0
  class CygCLI
    module Commands
      # @since 1.1.0
      # @api private
      module Db
        require "hanami/cyg_cli/commands/db/version"
        require "hanami/cyg_cli/commands/db/create"
        require "hanami/cyg_cli/commands/db/drop"
        require "hanami/cyg_cli/commands/db/migrate"
        require "hanami/cyg_cli/commands/db/rollback"
        require "hanami/cyg_cli/commands/db/prepare"
        require "hanami/cyg_cli/commands/db/apply"
        require "hanami/cyg_cli/commands/db/console"
      end
    end

    register "db" do |prefix|
      prefix.register "version",  Commands::Db::Version
      prefix.register "create",   Commands::Db::Create
      prefix.register "drop",     Commands::Db::Drop
      prefix.register "migrate",  Commands::Db::Migrate
      prefix.register "rollback", Commands::Db::Rollback
      prefix.register "prepare",  Commands::Db::Prepare
      prefix.register "apply",    Commands::Db::Apply
      prefix.register "console",  Commands::Db::Console
    end
  end
end
