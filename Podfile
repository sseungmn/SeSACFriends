# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'SeSACFriends' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SeSACFriends
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Socket.IO-Client-Swift'
  
  pod 'IQKeyboardManagerSwift'
  pod 'Toast-Swift'
  pod 'SnapKit'
  pod 'Then'
  
  pod 'RxDataSources'
  pod 'RxSwift'
  pod 'Moya/RxSwift'

  target 'SeSACFriendsTests' do
    inherit! :search_paths
    # Pods for testing
    
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Moya/RxSwift'
  end

  target 'SeSACFriendsUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
