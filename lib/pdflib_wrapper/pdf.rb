module PdflibWrapper
	class Pdf
		attr_accessor :pdf
	  def initialize(filepath, metadata={}, opts={})
	  	#pdflib likes to override the file, should do a check to see if file already exists
	  	#also pdflib like to make bad pdf if you dont close pdf after begin_document
	  	@pdf = PDFlib.new

	  	#options legacy, return, exception
	  	@pdf.set_parameter("errorpolicy", opts[:errorpolicy] || "exception")

	  	#TODO: better support for begin document options
	  	unless opts[:dont_create_document]
		  	key_values = [:masterpassword, :userpassword, :permissions, :moddate]
		  	@pdf.begin_document(filepath.to_s, OptionListMapper.create_options('', key_values, [], opts)) 

				@pdf.set_info("Subject", metadata[:subject]) if metadata[:subject]
				@pdf.set_info("Title", metadata[:title]) if metadata[:title]
		    @pdf.set_info("Creator", metadata[:creator]) if metadata[:creator]
		    @pdf.set_info("Author", metadata[:author]) if metadata[:author]
		    @pdf.set_info("Keywords", metadata[:keywords].join(', ')) if metadata[:keywords] && metadata[:keywords].is_a?(Array)
		    @pdf.set_info("Trapped", metadata[:trapped]) if opts[:trapped] && [true, false].include?(opts[:trapped])

		    #TODO: support more of the Global Options of pdflib
		    @pdf.set_parameter("licensefile", opts[:license_path] ) if opts[:license_path] #TODO: check if file exists
		    @pdf.set_value("compress", opts[:compress] ) if opts[:compress] && opts[:compress].is_a?(Fixnum) #TODO: check range (1..9)

		    @current_page = Page.new(@pdf, 1, 1).save if opts[:with_blank_page]
		  end
	  end

	  def save
	  	@pdf.end_document("")
	  end
	  alias_method :close, :save

	  def page_count
	  	#@pdf.get_pdi_value("/Root/Pages/Count", pdf_handle, -1, 0).to_i
	  end


	  #TODO: pull font and printing text into new class
	  def set_text(font, size)
	  	@pdf.setfont(font, size)
	  end

	  def set_text_position(width, height)
	  	@pdf.set_text_pos(width, height)
	  end

	  def set_text_and_position(font,size,width,height)
	  	set_text(font,size)
	  	set_text_position(width, height)
	  end

	  def print(text)
	  	@pdf.show(text)
	  end

	  def print_on_newline(text)
	  	@pdf.continue_text(text)
	  end

	  def create_font(font, encoding, opts={})
	  	#TODO: support opts
	  	#  ascender, autocidfont, autosubsetting, capheight, descender, dropcorewidths, embedding, encoding, fallbackfonts, fontname, initialsubset, keepfont, keepnative, linegap, metadata, optimizeinvisible, readfeatures, readkerning, readselectors, readshaping, replacementchar, skipembedding, skipposttable, subsetlimit, subsetminsize, subsetting, unicodemap, vertical, xheight
	  	@pdf.load_font(font, encoding, "" )
	  end

	  def new_page(width, height, opts={})
	  	#TODO: support opts
	  	@current_page = Page.new(@pdf, width, height, opts)
	  end

	  def open_pdf(filepath, opts={})
	  	#TODO: support opts
	    @current_pdf = External::Pdf::Document.new(@pdf, filepath, opts)
	  end

	  def open_pdf_page(page_number=1, pdf=nil, opts={})
	  	#TODO: support opts
	  	current_pdf = pdf || @current_pdf
	  	descriptor_page = External::Pdf::Page.new(@pdf, current_pdf, page_number, "" )
	  end

	  def embed_pdf_page(page, x, y, opts={})
	  	Page.embed(@pdf, page, x, y, opts.dup)
	  end
	end
end