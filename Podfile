# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'GameStarDB' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Reusable'

  # Rx pods
  pod 'RxSwift'
  pod 'RxSwiftExt'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxFlow'

  # Redux pods
  pod 'ReactorKit'

  # Networking pods
  pod 'Moya/RxSwift', '~> 14.0'

  # Test pods
  target 'GameStarDBTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'RxTest'
  end

  target 'GameStarDBUITests' do
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end
