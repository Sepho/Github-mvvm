# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'GithubRepoExample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Moya/RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'SwiftyJSON'

  # Pods for GithubRepoExample

  target 'GithubRepoExampleTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
