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
  							trapped: 	false,
  							compress: 9}
  	opts = {with_blank_page: true}

  	PdflibWrapper::Pdf.new(filepath, metadata, opts).save

  	File.exists?(filepath).should be_true
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
end
