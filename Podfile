# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyFit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyFit
  pod 'GoogleMaps'
  pod 'RealmSwift'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings[‘EXCLUDED_ARCHS[sdk=iphonesimulator*]’] = ‘arm64’
  end
end
