module PdflibWrapper
	class Page
		attr_accessor :page
		def initialize(pdf, width, height, opts={})
			#TODO: support opts
			@pdf = pdf
			@page = @pdf.begin_page_ext(width, height, "")
		end

		def save(opts={})
			#TODO: support opts
			@pdf.end_page_ext("")  
		end
		alias_method :close, :save

		class << self
			def embed(pdf, page, x, y, opts)
		  	key_values = [:dpi, :boxsize, :rotate, :blind, :matchbox, :orientate, :position, :showborder, :fitmethod]
				pdf.fit_pdi_page(page.page, x, y, OptionListMapper.create_options('', key_values, [], opts))
			end
		end

	end
end