module PdflibWrapper
  module External
    module Image
      class Document
        VALID_IMAGE_TYPES = %Q{bmp ccitt gif jbig2 jpeg jpeg2000 png raw tiff}
        attr_accessor :document, :image_type
        def initialize(pdf, filepath, opts={})
          #TODO: support opts
          if opts[:image_type].nil? || !opts[:image_type].kind_of?(String) || opts[:image_type].empty? || !VALID_IMAGE_TYPES.include?(opts[:image_type])
            @image_type = "auto"
          else
            @image_type = opts[:image_type]
          end
          @pdf = pdf
          @document = @pdf.load_image(@image_type, filepath, OptionListMapper.create_options('', [], [], opts) )
        end

        def close
          #TODO: support opts
          @pdf.close_image(@document)
        end
      end
    end
  end
end