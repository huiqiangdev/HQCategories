version = "0.0.2";

Pod::Spec.new do |s|
  s.name         = "HQCategories"
  s.version      = version
  s.summary      = " ios Categories"
  s.description  = <<-DESC
                      some categories used in my project 
                       DESC
  s.homepage     = "https://github.com/huiqiangdev/HQCategories"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "heart_queen" => "huiqiangdev@icloud.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.requires_arc = true
  s.framework    = "UIKit"
  s.source       = { :git => "https://github.com/huiqiangdev/HQCategories.git", :tag => "#{s.version}" }
  s.source_files = "HQCategories", "HQCategories/*.{h}","HQCategories/**/*.{h,m}"
  #s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end