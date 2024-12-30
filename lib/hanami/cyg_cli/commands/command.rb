require 'hanami'
require 'hanami/environment'
require 'hanami/components'
require 'dry/cli/command'
require 'hanami/cyg_cli/commands/project'
require 'hanami/cyg_cli/commands/templates'
require 'concurrent'
require 'hanami/cyg_utils/files'
require 'erb'

module Hanami
  # Hanami CygCLI
  #
  # @since 1.1.0
  class CygCLI
    module Commands
      # Abstract command
      #
      # @since 1.1.0
      class Command < Dry::CLI::Command
        # @since 1.1.0
        # @api private
        def self.inherited(component)
          super

          component.class_eval do
            @_requirements = Concurrent::Array.new
            extend ClassMethods
            prepend InstanceMethods
          end
        end

        # Class level interface
        #
        # @since 1.1.0
        module ClassMethods
          # Requires an internal Hanami component
          #
          # @param names [Array<String>] the name of one or more components
          #
          # @since 1.1.0
          #
          # @example
          #   require "hanami/cyg_cli/commands"
          #
          #   module HanamiDatabaseHelpers
          #     class TruncateTables < Hanami::CygCLI::Commands::Command
          #       requires "model.configuration"
          #
          #       def call(*)
          #         url = requirements["model.configuration"].url
          #         # ...
          #       end
          #     end
          #   end
          #
          #   Hanami::CygCLI.register "db truncate", HanamiDatabaseHelpers::TruncateTables
          def requires(*names)
            requirements.concat(names)
          end

          # @since 1.1.0
          # @api private
          def requirements
            @_requirements
          end
        end

        # @since 1.1.0
        # @api private
        module InstanceMethods
          # @since 1.1.0
          # @api private
          def call(**options)
            if self.class.requirements.any?
              environment = Hanami::Environment.new(options)
              environment.require_project_environment

              requirements.resolved('environment', environment)
              requirements.resolve(self.class.requirements)

              options = environment.to_options.merge(options)
            end

            super(**options)
          rescue StandardError => e
            warn e.message
            warn e.backtrace.join("\n\t")
            exit(1)
          end
        end

        # @since 1.1.0
        # @api private
        def initialize(out: $stdout, files: CygUtils::Files)
          @out       = out
          @files     = files
          @templates = Templates.new(self.class)
        end

        private

        # Template renderer
        #
        # @since 1.1.0
        # @api private
        class Renderer
          # @since 1.1.0
          # @api private
          TRIM_MODE = "-".freeze

          # @since 1.1.0
          # @api private
          def initialize
            freeze
          end

          # @since 1.1.0
          # @api private
          def call(template, context)
            ::ERB.new(template, nil, TRIM_MODE).result(context)
          end
        end

        # @since 1.1.0
        # @api private
        SAY_FORMATTER = "%<operation>12s  %<path>s\n".freeze

        # @since 1.1.0
        # @api private
        attr_reader :out

        # @since 1.1.0
        # @api private
        attr_reader :files

        # @since 1.1.0
        # @api private
        attr_reader :templates

        # @since 1.1.0
        # @api private
        def render(path, context)
          template = File.read(path)
          renderer = Renderer.new

          renderer.call(template, context.binding)
        end

        # @since 1.1.0
        # @api private
        def generate_file(source, destination, context)
          files.write(
            destination,
            render(source, context)
          )
        end

        # @since 1.1.0
        # @api private
        def say(operation, path)
          out.puts(SAY_FORMATTER % { operation: operation, path: path }) # rubocop:disable Style/FormatString
        end

        # @since 1.1.0
        # @api private
        def project
          Project
        end

        # @since 1.1.0
        # @api private
        def requirements
          Hanami::Components
        end
      end
    end
  end
end
