module Zebra
  module Zpl
    class Image
      include Printable

      class InvalidSizeError < StandardError; end
      class InvalidRotationError < StandardError; end
      class InvalidThresholdError < StandardError; end

      attr_reader :path
      attr_writer :invert, :compress

      def path=(p)
        @img = Img2Zpl::Image.open(p)
        @path = @img.path
      end

      def source
        @img
      end

      alias src source

      def width=(value)
        raise InvalidSizeError.new('Invalid image width') unless value.to_i.positive?
        @width = value.to_i
      end

      def width
        @width || @img.width
      end

      def height=(value)
        raise InvalidSizeError.new('Invalid image height') unless value.to_i.positive?
        @height = value.to_i
      end

      def height
        @height || @img.height
      end

      def rotation=(rot)
        raise InvalidRotationError unless (true if Float(rot) rescue false)
        @rotation = rot
      end

      def rotation
        @rotation || 0
      end

      def black_threshold=(value)
        raise InvalidThresholdError.new('Invalid black threshold') unless value.to_f >= 0 && value.to_f <= 1
        @black_threshold = value.to_f
      end

      def black_threshold
        @black_threshold || 0.5
      end

      def invert
        @invert || false
      end

      def compress
        @compress || true
      end

      def to_zpl
        check_attributes
        modify
        graphics = @img.to_zpl(
          black_threshold: black_threshold,
          invert: invert,
          compress: compress
        )
        "^FO#{x},#{y}#{graphics}"
      end

      private

      def has_data?
        false
      end

      def modify
        @img.resize("#{width}x#{height}") if @width || @height
        @img.rotate(@rotation) if @rotation
      end

      def check_attributes
        super
        raise MissingAttributeError.new("the path is invalid or not given") unless @path
      end

    end
  end
end
