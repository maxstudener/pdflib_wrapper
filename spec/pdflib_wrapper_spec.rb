require 'tempfile'

require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper") 

describe PdflibWrapper do
  it "creates blank pdf" do
  	filepath = Tempfile.new("generate_test.pdf").path
  	metadata = {author: 	'Max Studener',
  							subject: 	'Testing Pdf',
  							title: 		'This is a test pdf',
  							creator: 	'This Test',
  							keywords: ['Array', 'of', 'keywords'],
  							trapped: 	false}
  	opts = {with_blank_page: true}

  	PdflibWrapper::Pdf.new(filepath, metadata, opts).save

  	File.exists?(filepath).should be_true
  end

  it "just creates Pdflib handle" do
    PdflibWrapper::Pdf.new('', {}, {dont_create_document: true})
  end

  it "embeds pdf inside pdf" do
  	embed_tempfile = Tempfile.new("embed.pdf")
  	embed_pdf = PdflibWrapper::Pdf.new(embed_tempfile.path)
  	embed_pdf.new_page(2,4).save
  	embed_pdf.save

  	new_tempfile = Tempfile.new("new.pdf")
  	new_pdf = PdflibWrapper::Pdf.new(new_tempfile.path)
  	
  	external_pdf = new_pdf.open_pdf(embed_tempfile.path)
  	external_pdf_page_one = new_pdf.open_pdf_page

  	new_page = new_pdf.new_page(10,10)

  	opts = {dpi: 288, box_size: [2,4], fit_options: ['fitmethod', 'meet']}
  	new_pdf.embed_pdf_page(external_pdf_page_one, 0, 0, opts)

  	new_page.save
  	external_pdf_page_one.close
  	external_pdf.close

  	new_pdf.save
  end

  it "creates font" do
  	tempfile = Tempfile.new("generate_test.pdf")
  	pdf = PdflibWrapper::Pdf.new(tempfile.path, {}, {with_blank_page: true})
  	font = pdf.create_font("Helvetica", "winansi")
  	font.should equal(pdf.pdf.load_font("Helvetica", "winansi", "" ))
  	pdf.close
  end

  it "gets width of external pdf" do
  	width = 2.0
  	external_tempfile = Tempfile.new("external.pdf")
  	external_pdf = PdflibWrapper::Pdf.new(external_tempfile.path)
  	external_pdf.new_page(width,4).save
  	external_pdf.save


  	test_pdf = PdflibWrapper::Pdf.new(Tempfile.new("test.pdf").path, {}, {with_blank_page: true})
  	document = test_pdf.open_pdf(external_tempfile.path)
  	page = test_pdf.open_pdf_page(1)
  	page.width.should be(width)
  end

  it "get height of external pdf" do
  	height = 4.0
  	external_tempfile = Tempfile.new("external.pdf")
  	external_pdf = PdflibWrapper::Pdf.new(external_tempfile.path)
  	external_pdf.new_page(2, height).save
  	external_pdf.save


  	test_pdf = PdflibWrapper::Pdf.new(Tempfile.new("test.pdf").path, {}, {with_blank_page: true})
  	document = test_pdf.open_pdf(external_tempfile.path)
  	page = test_pdf.open_pdf_page(1)
  	page.height.should be(height)
  end

  it "opens password protected pdf" do
    password_tempfile = Tempfile.new("external.pdf")
    PdflibWrapper::Pdf.new(password_tempfile.path, {}, {with_blank_page: true, masterpassword: 'magic'}).save

    pdf_handler = PdflibWrapper::Pdf.new('', {}, {dont_create_document: true})
    pdf_handler.open_pdf(password_tempfile.path, {password: 'magic'})
  end
end
