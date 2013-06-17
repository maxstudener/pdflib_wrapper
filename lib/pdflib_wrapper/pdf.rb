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
	  	begin_doc_opts = ""
	  	begin_doc_opts << "masterpassword=#{opts[:master_password]} " if opts[:master_password]
	  	begin_doc_opts << "permissions={#{opts[:permissions].join(' ')}} " if opts[:permissions] && opts[:permissions].is_a?(Array)
	  	@pdf.begin_document(filepath, begin_doc_opts)

			@pdf.set_info("Subject", metadata[:subject]) if metadata[:subject]
			@pdf.set_info("Title", metadata[:title]) if metadata[:title]
	    @pdf.set_info("Creator", metadata[:creator]) if metadata[:creator]
	    @pdf.set_info("Author", metadata[:author]) if metadata[:author]
	    @pdf.set_info("Keywords", metadata[:keywords].join(', ')) if metadata[:keywords] && metadata[:keywords].is_a?(Array)
	    @pdf.set_info("Trapped", metadata[:trapped]) if opts[:trapped] && [true, false].include?(opts[:trapped])

	    #TODO: support more of the Global Options of pdflib
	    @pdf.set_parameter("licensefile", opts[:license_path] ) if opts[:license_path]
	    @pdf.set_parameter("compress", opts[:compress] ) if opts[:compress] && opt

	    @current_page = Page.new(@pdf, 1, 1).save if opts[:with_blank_page]
	  end

	  def save
	  	@pdf.end_document("")
	  end
	  alias_method :close, :save

	  def page_count
	  	#@pdf.get_pdi_value("/Root/Pages/Count", pdf_handle, -1, 0).to_i
	  end

	  def create_font(font, encoding, opts={})
	  	#TODO: support opts
	  	#  ascender, autocidfont, autosubsetting, capheight, descender, dropcorewidths, embedding, encoding, fallbackfonts, fontname, initialsubset, keepfont, keepnative, linegap, metadata, optimizeinvisible, readfeatures, readkerning, readselectors, readshaping, replacementchar, skipembedding, skipposttable, subsetlimit, subsetminsize, subsetting, unicodemap, vertical, xheight
	  	@pdf.load_font(font, encoding, "" )
	  end

	  def new_page(width, height, opts={})
	  	#TODO: support opts
	  	@current_page = Page.new(@pdf, width, height, opts.dup)
	  end

	  def open_pdf(filepath, opts={})
	  	#TODO: support opts
	    @current_pdf = External::Pdf::Document.new(@pdf, filepath, opts.dup)
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