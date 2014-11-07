module JSONAPI
  class Association
    attr_reader :acts_as_set, :foreign_key, :type, :options, :name, :class_name

    def initialize(name, options={})
      @name                = name.to_s
      @options             = options
      @acts_as_set         = options.fetch(:acts_as_set, false) == true
      @key                 = options[:key] ? options[:key].to_sym : nil

      if @key.nil?
        @foreign_key  = options[:foreign_key ] ? options[:foreign_key ].to_sym : nil
      else
        # :nocov:
        warn '[DEPRECATION] `key` is deprecated in associations.  Please use `foreign_key` instead.'
        # :nocov:
      end
    end

    def primary_key
      @primary_key ||= Resource.resource_for(@name)._primary_key
    end

    def href(base)
      "#{base}/#{type}"
    end

    class HasOne < Association
      def initialize(name, options={})
        super
        @class_name = options.fetch(:class_name, name.to_s.capitalize)
        @type = class_name.underscore.pluralize.to_sym
        @foreign_key ||= @key.nil? ? "#{name}_id".to_sym : @key
      end
    end

    class HasMany < Association
      def initialize(name, options={})
        super
        @class_name = options.fetch(:class_name, name.to_s.capitalize.singularize)
        @type = class_name.underscore.pluralize.to_sym
        @foreign_key  ||= @key.nil? ? "#{name.to_s.singularize}_ids".to_sym : @key
        self.href_style = options.fetch(:href_style, :default)
      end

      def href_style=(href_style)
        raise ArgumentError.new(href_style) unless [:default, :id_based, :filter_based].include?(href_style)
        @href_style = href_style
      end

      def href_style(default = JSONAPI.configuration.has_many_href_style)
        @href_style == :default ? default : @href_style
      end
    end
  end
end
