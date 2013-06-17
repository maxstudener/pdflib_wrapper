module PdflibWrapper
	module External
		module Pdf
			class Page
				attr_accessor :page
				def initialize(pdf, document, page_number=1, opts={})
					#TODO: support opts
					@pdf = pdf
					@document = document
					@page = @pdf.open_pdi_page( @document.document, page_number, "" )
				end

				def width(page=0)
		      @pdf.get_pdi_value("width",  @document.document, @page, page )
		      #width = @pdf.pcos_get_number(descriptor_pdf, "pages[0]/width")
				end

				def height(page=0)
					@pdf.get_pdi_value("height", @document.document, @page, page )
		      #height = @pdf.pcos_get_number(descriptor_pdf, "pages[0]/height")
				end

				def close
					@pdf.close_pdi_page(@page)
				end

			end
		end
	end
end