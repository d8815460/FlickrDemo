source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'FlickrDemo' do
  pod 'ReachabilitySwift', '~> 3',:inhibit_warnings => true
  pod 'Alamofire',:inhibit_warnings => true
  pod 'MJRefresh',:inhibit_warnings => true
  pod 'IQKeyboardManagerSwift',:inhibit_warnings => true
  pod 'RealmSwift',:inhibit_warnings => true
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
