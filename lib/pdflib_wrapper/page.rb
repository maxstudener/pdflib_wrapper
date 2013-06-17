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
				#TODO: support more opts
				opts_string = ""
				opts_string << "dpi=#{opts[:dpi]} " if opts[:dpi]
				opts_string << "boxsize={#{opts[:box_size][0]} #{opts[:box_size][1]}} " if opts[:box_size] && opts[:box_size].is_a?(Array)
				opts_string << opts[:fit_options].join(' ') if opts[:fit_options] && opts[:fit_options].is_a?(Array)
				pdf.fit_pdi_page(page.page, x, y, opts_string)
			end
		end

	end
end