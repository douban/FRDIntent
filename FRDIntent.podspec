Pod::Spec.new do |s|

  s.name         = "FRDIntent"
  s.version      = "0.8.1"
  s.summary      = "FRDIntent can handle the call between view controller"

  s.description  = "FRDIntent has two components URLRoutes and Intent, using for calling view controllers inner app or outer app."
  s.homepage     = "https://github.com/douban/FRDIntent"
  s.license      = { :type => 'MIT', :text => 'LICENSE.md' }
  s.author       = { "lincode" => "guolin@douban.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/douban/FRDIntent.git", :tag => "#{s.version}" }

  s.subspec 'Intent' do |intent|
    intent.source_files  = 'FRDIntent/Source/Intent/**/*.swift', 'FRDIntent/Source/Core/**/*.swift'
    intent.frameworks    = 'UIKit'
  end

  s.subspec 'URLRoutes' do |urlroutes|
    urlroutes.source_files  = 'FRDIntent/Source/URLRoutes/*.swift'
    urlroutes.dependency 'FRDIntent/Intent'
  end

  s.subspec 'OCIntent' do |ocintent|
    ocintent.source_files  = 'FRDIntent/Source/OCIntent/*.{h, m}'
    ocintent.dependency 'FRDIntent/Intent'
  end

  s.default_subspec = 'URLRoutes', 'OCIntent'

end
