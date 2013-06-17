require "pdflib_wrapper/version"
require "pdflib_wrapper/pdf"
require "pdflib_wrapper/page"
require "pdflib_wrapper/external/pdf/document"
require "pdflib_wrapper/external/pdf/page"
require 'os'
require 'PDFlib.bundle' if OS.mac?
require 'PDFlib.so' if OS.linux?
require "PDFlib"

module PdflibWrapper
end
