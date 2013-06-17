module PdflibWrapper
	module External
		module Pdf
			class Document
				attr_accessor :document
				def initialize(pdf, filepath, opts={})
					#TODO: support opts
					@pdf = pdf
					@document = @pdf.open_pdi_document( filepath, "" )
				end

				def close
					#TODO: support opts
					@pdf.close_pdi_document(@document)
				end
			end
		end
	end
end
