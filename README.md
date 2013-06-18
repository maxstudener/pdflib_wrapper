# PdflibWrapper

Pdflib Wrapper is a wrapper around PDFLib's api. PDFlib is a commerical software and requires a license for use without watermarks. PDFlib only supports ruby for linux and mac. To purchase your license visit http://www.pdflib.com/download/pdflib-family/pdflib-9/. This wrapper imports the ruby mri 2.0 files. This gem only supports limited parts of the api but forks are welcome as long as there are passing tests.

## Installation

Add this line to your application's Gemfile:

    gem 'pdflib_wrapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdflib_wrapper

## Usage

Creating PDF
```ruby
metadata = {author:   'Max Studener',
            subject:  'Testing Pdf',
            title:    'This is a test pdf',
            creator:  'This Test',
            keywords: ['Array', 'of', 'keywords']}
opts = {license_path: Rails.root.join('config','pdflib.license')}

pdf = PdflibWrapper::Pdf.new('/tmp/test.pdf', metadata, opts)
new_page = new_pdf.new_page(10,10)
#Do stuff
new_page.save
pdf.save
```

Opening PDF
```ruby
pdf = PdflibWrapper::Pdf.open_pdf(external_pdf.path)
page = pdf.open_page(1)
#Do stuff
page.close
pdf.close
```

Open/Create password protected PDF
```ruby
tempfile = Tempfile.new("external.pdf")
passworded_pdf = PdflibWrapper::Pdf.new(tempfile.path, {}, {with_blank_page: true, masterpassword: 'magic'}).save

PdflibWrapper::Pdf.open_pdf(passworded_pdf.path, {password: 'magic'})
```

Embed PDF inside PDF
```ruby
embed_pdf = PdflibWrapper::Pdf.new(Tempfile.new("embed.pdf").path)
embed_pdf.new_page(2,4).save
embed_pdf.save

new_pdf = PdflibWrapper::Pdf.new(Tempfile.new("new.pdf").path)

external_pdf = new_pdf.open_pdf(embed_pdf.path)
external_pdf_page_one = new_pdf.open_pdf_page

new_page = new_pdf.new_page(10,10)

new_pdf.embed_pdf_page(external_pdf_page_one, 0, 0)

new_page.save
external_pdf_page_one.close
external_pdf.close
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
