Pod::Spec.new do |s|

  s.name         = "CCHTTPRequest"
  s.version      = "1.0.0"
  s.summary      = "No-frills networking for iOS."
  s.homepage     = "https://github.com/catshive/CCHTTPRequest"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Cathy Shive" => "catshive@gmail.com" }
  s.social_media_url   = "http://twitter.com/catshive"
  s.platform     = :ios
  s.source       = { :git => "https://github.com/catshive/CCHTTPRequest.git"}
  s.source_files  = "Classes", "Classes/CCHTTPRequest.{h,m}"
  # s.requires_arc = true

end
