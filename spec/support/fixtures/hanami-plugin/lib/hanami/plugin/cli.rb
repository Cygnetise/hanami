require "hanami/cyg_cli/commands"

module Hanami
  module Plugin
    module CygCLI
      class Version < Hanami::CygCLI::Command
        desc "Print Hanami plugin version"

        def call(*)
          puts "v#{Hanami::Plugin::VERSION}"
        end
      end
    end
  end
end

Hanami::CygCLI.register "plugin version", Hanami::Plugin::CLI::Version
