module Hanami
  # Hanami CygCLI
  #
  # @since 1.1.0
  class CygCLI
    module Commands
      # @since 1.1.0
      # @api private
      module Assets
        require "hanami/cyg_cli/commands/assets/precompile"
      end
    end

    register "assets precompile", Commands::Assets::Precompile
    # register "assets compile", Assets::Compile
  end
end
