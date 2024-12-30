require 'dry/cli'
require 'ostruct'

module Hanami
  # Hanami CygCLI
  #
  # @since 1.1.0
  class CygCLI
    # Register a command to expand Hanami CygCLI
    #
    # @param name [String] the command name
    # @param command [NilClass,Hanami::CygCLI::Command,Hanami::CygCLI::Commands::Command]
    #   the optional command
    # @param aliases [Array<String>] an optional list of aliases
    #
    # @since 1.1.0
    #
    # @example Third party gem
    #   require "hanami/cyg_cli/commands"
    #
    #   module Hanami
    #     module Webpack
    #       module CygCLI
    #         module Commands
    #           class Generate < Hanami::CygCLI::Command
    #             desc "Generate Webpack config"
    #
    #             def call(*)
    #               # ...
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    #
    #   Hanami::CygCLI.register "generate webpack", Hanami::Webpack::CLI::Commands::Generate
    #
    #   # $ bundle exec hanami generate
    #   # Commands:
    #   #   hanami generate action APP ACTION                    # Generate an action for app
    #   #   hanami generate app APP                              # Generate an app
    #   #   hanami generate mailer MAILER                        # Generate a mailer
    #   #   hanami generate migration MIGRATION                  # Generate a migration
    #   #   hanami generate model MODEL                          # Generate a model
    #   #   hanami generate secret [APP]                         # Generate session secret
    #   #   hanami generate webpack                              # Generate Webpack configuration
    def self.register(name, command = nil, aliases: [], &blk)
      Commands.register(name, command, aliases: aliases, &blk)
    end

    # CygCLI commands registry
    #
    # @since 1.1.0
    # @api private
    module Commands
      extend Dry::CLI::Registry

      # CygCLI command context
      #
      # @since 1.1.0
      # @api private
      class Context < OpenStruct
        # @since 1.1.0
        # @api private
        def initialize(data)
          data = data.each_with_object({}) do |(k, v), result|
            v = CygUtils::String.new(v) if v.is_a?(::String)
            result[k] = v
          end

          super(data)
          freeze
        end

        # @since 1.1.0
        # @api private
        def with(data)
          self.class.new(to_h.merge(data))
        end

        # @since 1.1.0
        # @api private
        def binding
          super
        end
      end

      require "hanami/cyg_cli/commands/command"
      require "hanami/cyg_cli/commands/assets"
      require "hanami/cyg_cli/commands/console"
      require "hanami/cyg_cli/commands/db"
      require "hanami/cyg_cli/commands/destroy"
      require "hanami/cyg_cli/commands/generate"
      require "hanami/cyg_cli/commands/new"
      require "hanami/cyg_cli/commands/routes"
      require "hanami/cyg_cli/commands/server"
      require "hanami/cyg_cli/commands/version"
    end
  end
end
