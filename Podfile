# Uncomment the next line to define a global platform for your project
platform :ios, '9.3'
use_frameworks!

target 'Golos' do
    
    pod 'Down'

    # Fast, non-deadlocking parallel object cache for iOS, tvOS and OS X
    pod 'PINCache'
    
    # A tool to enforce Swift style and conventions
    pod 'SwiftLint'
    
    pod 'IQKeyboardManagerSwift', '~> 5.0'

    # CoreBitcoin
#    pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'

    # Distribution & Crash report
    pod 'Fabric'
    pod 'Crashlytics'
    
    # Firebase
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    
    # Design
    pod 'LayoutKit', '~> 7.0'
    
    # Pods for golos-ios
#    pod 'GoloSwift', '~> 1.1'
    pod 'GoloSwift', :git => "https://github.com/GolosChain/GoloSwift.git"
#    pod 'GoloSwift', :git => "https://github.com/GolosChain/GoloSwift.git", :tag => "1.1.7"

end

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
