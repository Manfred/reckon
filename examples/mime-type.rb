require 'test/reckon'

class MimeType
  attr_accessor :maintype, :subtype, :charset
  def self.parse(input)
    mime_type = new
    main, rest = input.split(';')
    
    main = main.strip.split('/')
    mime_type.maintype = main.first
    mime_type.subtype = main.last
    
    rest.split.each do |kval|
      name, value = kval.strip.split('=')
      mime_type.send("#{name}=", value)
    end
    
    mime_type
  end
end

testing "MimeType" do
  testing "should parse simple mime-types" do
    mimetype = MimeType.parse('application/xml; charset=utf-8')
    
    expects(mimetype.maintype) == 'application'
    expects(mimetype.subtype) == 'xml'
    expects(mimetype.charset) == 'utf-8'
  end
end