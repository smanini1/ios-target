platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'ios-target' do
  pod 'Alamofire', '~> 4.7.3'
  pod 'IQKeyboardManagerSwift', '~> 6.1.1'
  pod 'RSFontSizes', '~> 1.0.2'
  pod 'SDWebImage', '~> 5.0'

  # FB SDK ---
  pod 'FBSDKCoreKit', '~> 4.33.0'
  pod 'FBSDKLoginKit', '~> 4.33.0'
  # ------
end

target 'AcceptanceTests' do
  pod 'KIF', '~> 3.7.4', :configurations => ['Debug']
  pod 'KIF/IdentifierTests', '~> 3.7.3', :configurations => ['Debug']
  pod 'OHHTTPStubs/Swift', '~> 6.1.0', :configurations => ['Debug']
end
