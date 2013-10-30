require 'tempfile'
require 'PDFlib.bundle'

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
    #TODO: get document count and make sure its 0
  end

  it "store filepath" do
    path = 'testing'
    pdf = PdflibWrapper::Pdf.new(path, {}, {dont_create_document: true})
    pdf.path.should be(path)
  end

  it "embeds pdf inside pdf" do
  	embed_pdf = PdflibWrapper::Pdf.new(Tempfile.new('test.pdf').path)
  	new_page = embed_pdf.new_page(100,100)
    font = embed_pdf.create_font("Helvetica", "winansi")
    embed_pdf.set_text_and_position(font, 4, 0, 40)
    embed_pdf.print("THIS BETTER WORK OR ELSE THIS GEM IS GOING DOWN THE DRAIN")
    new_page.save
  	embed_pdf.save

    #new_pdf_temp = Tempfile.new("new.pdf")
    tempfile_one = Tempfile.new('test1.pdf')
  	new_pdf = PdflibWrapper::Pdf.new(tempfile_one.path)
  	
  	external_pdf = new_pdf.open_pdf(embed_pdf.path)
  	external_pdf_page_one = new_pdf.open_pdf_page

  	new_page = new_pdf.new_page(200,200)
  	new_pdf.embed_pdf_page(external_pdf_page_one, 0, 0, { dpi: 288, boxsize: [ 50, 50 ] , position: 'center', fitmethod: 'meet' })

    external_pdf_page_one.close
    external_pdf.close
  	new_page.save
  	new_pdf.save

    pdf = PDFlib.new
    pdf.set_parameter("errorpolicy","exception")
    tempfile_two = Tempfile.new('test2.pdf')
    pdf.begin_document(tempfile_two.path, "")

    external_pdf = pdf.open_pdi_document( embed_pdf.path, "" )
    external_pdf_page_one = pdf.open_pdi_page( external_pdf, 1, "" )

    pdf.begin_page_ext(200, 200, "")
    pdf.fit_pdi_page(external_pdf_page_one, 0, 0, "dpi=288 boxsize={50 50} position=center fitmethod=meet")

    pdf.close_pdi_page(external_pdf_page_one)
    pdf.close_pdi_document(external_pdf)
    pdf.end_page_ext("")
    pdf.end_document("")



    tempfile_one.size.should be(tempfile_two.size)
  end

  it "embeds image inside pdf" do
    
    test_image_path = File.join(File.expand_path(File.dirname(__FILE__)), 'images', 'test.gif')

    tempfile_one = Tempfile.new("new1.pdf")
    pdf = PdflibWrapper::Pdf.new(tempfile_one.path)
    new_page = pdf.new_page(500,600)

    embed_image = PdflibWrapper::External::Image::Document.new(pdf.pdf, test_image_path)
    
    pdf.embed_image(embed_image, 0, 0, { dpi: 288, boxsize: [ 407, 580 ], position: 'center', fitmethod: 'meet' })

    new_page.save
    pdf.save


    tempfile_two = Tempfile.new('new2.pdf')
    pdf = PDFlib.new
    pdf.set_parameter("errorpolicy","exception")
    pdf.begin_document(tempfile_two.path, "")
    pdf.begin_page_ext(500, 600, "")

    external_image = pdf.load_image( "auto", test_image_path, "" )

    pdf.fit_image(external_image, 0, 0, "dpi=288 boxsize={407 580} position=center fitmethod=meet")

    pdf.close_image(external_image)
    pdf.end_page_ext("")
    pdf.end_document("")

    tempfile_one.size.should be(tempfile_two.size)
  end

  it "creates font" do
  	pdf = PdflibWrapper::Pdf.new(Tempfile.new("generate_test.pdf").path, {}, {with_blank_page: true})
  	font = pdf.create_font("Helvetica", "winansi")
  	font.should equal(pdf.pdf.load_font("Helvetica", "winansi", "" ))
  	pdf.close
  end

  it "gets width of external pdf" do
  	width = 2.0
  	external_pdf = PdflibWrapper::Pdf.new(Tempfile.new("external.pdf").path)
  	external_pdf.new_page(width,4).save
  	external_pdf.save

  	test_pdf = PdflibWrapper::Pdf.open_pdf(external_pdf.path)
  	page = test_pdf.open_page(1)
  	page.width.should be(width)
  end

  it "get height of external pdf" do
  	height = 4.0
  	external_pdf = PdflibWrapper::Pdf.new(Tempfile.new("external.pdf").path)
  	external_pdf.new_page(2, height).save
  	external_pdf.save

    test_pdf = PdflibWrapper::Pdf.open_pdf(external_pdf.path)
    page = test_pdf.open_page(1)
  	page.height.should be(height)
  end

  it "opens password protected pdf" do
    password_pdf = PdflibWrapper::Pdf.new(Tempfile.new("external.pdf").path, {}, {with_blank_page: true, masterpassword: 'magic'}).save

    PdflibWrapper::Pdf.open_pdf(password_pdf.path, {password: 'magic'})
  end
end
