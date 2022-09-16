# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'Marketplace' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marketplace

pod 'SnapKit'
#pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift', '~> 9.5'
pod 'Firebase/Storage'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end