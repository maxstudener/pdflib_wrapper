module PdflibWrapper
	module External
		module Pdf
			class Document
				attr_accessor :document
				def initialize(pdf, filepath, opts={})
					#TODO: support opts
					key_values = [:password]
					singles = []
					@pdf = pdf
					@document = @pdf.open_pdi_document( filepath, OptionListMapper.create_options('', key_values, singles, opts) )
				end

			  def open_page(page_number=1, opts={})
			  	#TODO: support opts
			  	External::Pdf::Page.new(@pdf, self, page_number, "" )
			  end

				def close
					#TODO: support opts
					@pdf.close_pdi_document(@document)
				end
			end
		end
	end
end
