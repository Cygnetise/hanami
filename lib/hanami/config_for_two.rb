# frozen_string_literal: true

module Hanami
  class ConfigForTwo
    def assets
      require_relative "config_for_two/assets"
      Hanami::ConfigForTwo::Assets.new
    end
  end
end
