require 'test/reckon'

testing "MimeType" do
  testing "should parse simple mime-types" do
    mimetype = MimeType.parse('application/xml; charset=utf-8')
    
    expects(mimetype.type) == 'application'
    expects(mimetype.subtype) == 'xml'
    expects(mimetype.charset) == 'utf-8'
  end
end