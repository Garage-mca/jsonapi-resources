require 'jsonapi/formatter'
require 'jsonapi/operations_processor'
require 'jsonapi/active_record_operations_processor'

module JSONAPI
  class Configuration
    attr_reader :json_key_format,
                :key_formatter,
                :route_format,
                :route_formatter,
                :operations_processor,
                :allowed_request_params,
                :default_paginator,
                :default_page_size,
                :maximum_page_size,
                :use_text_errors

    def initialize
      #:underscored_key, :camelized_key, :dasherized_key, or custom
      self.json_key_format = :dasherized_key

      #:underscored_route, :camelized_route, :dasherized_route, or custom
      self.route_format = :dasherized_route

      #:basic, :active_record, or custom
      self.operations_processor = :active_record

      self.allowed_request_params = [:include, :fields, :format, :controller, :action, :sort, :page]

      # :none, :offset, :paged, or a custom paginator name
      self.default_paginator = :none

      self.default_page_size = 10
      self.maximum_page_size = 20
      self.use_text_errors = false
    end

    def json_key_format=(format)
      @json_key_format = format
      @key_formatter = JSONAPI::Formatter.formatter_for(format)
    end

    def route_format=(format)
      @route_format = format
      @route_formatter = JSONAPI::Formatter.formatter_for(format)
    end

    def operations_processor=(operations_processor)
      @operations_processor_name = operations_processor
      @operations_processor = JSONAPI::OperationsProcessor.operations_processor_for(@operations_processor_name)
    end

    def allowed_request_params=(allowed_request_params)
      @allowed_request_params = allowed_request_params
    end

    def default_paginator=(default_paginator)
      @default_paginator = default_paginator
    end

    def default_page_size=(default_page_size)
      @default_page_size = default_page_size
    end

    def maximum_page_size=(maximum_page_size)
      @maximum_page_size = maximum_page_size
    end

    def use_text_errors=(use_text_errors)
      @use_text_errors = use_text_errors
    end
  end

  class << self
    attr_accessor :configuration
  end

  @configuration ||= Configuration.new

  def self.configure
    yield(@configuration)
  end
end
