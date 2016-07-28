Pod::Spec.new do |spec|
  spec.name = "ILPDFKit"
  spec.version = "1.0.5"
  spec.summary = "A PDF toolset for iOS with an emphasis on form filling."
  spec.description = "A simple toolkit for filling out and saving PDF forms, and extracting PDF data."
  spec.platform = :ios, "8.0"
  spec.homepage         = "https://github.com/derekblair/ILPDFKit"
  spec.license          = "MIT"
  spec.author           = { "Derek Blair" => "derekjblair@gmail.com" }
  spec.source           =  { :git => "https://github.com/derekblair/ILPDFKit.git", :tag => "1.0.5" }
  spec.requires_arc = true
  spec.source_files = "ILPDFKit/**/*.{h,m}"
  spec.frameworks = "CoreGraphics"
  spec.public_header_files = "ILPDFKit/**/*.h"
end

