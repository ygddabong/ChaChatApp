platform :ios, '13.0'

target 'Cha Chat' do
  use_frameworks!

  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'FirebaseUI'
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'MessageKit'
end

# The pod versions pinned in Podfile.lock declare very old deployment targets
# (iOS 8/9), which recent Xcode versions refuse to build. Raise them to iOS 12.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
