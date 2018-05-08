# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'Golos' do
    
    pod 'Down'
    pod 'PINCache'
    pod 'SwiftLint'
    pod 'Locksmith'
    pod 'Starscream', '~> 3.0'
    pod 'BeyovaJSON', '~> 0.0'
    pod 'Localize-Swift', '~> 2.0'
    pod 'IQKeyboardManagerSwift', '~> 5.0'

    # CoreBitcoin
    pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'

    # Distribution & Crash report
    pod 'Fabric'
    pod 'Crashlytics'
    
    # Design
    pod 'LayoutKit', '~> 7.0'
    
    # Pods for golos-ios
    # pod 'GolosBlockchain', :git => "https://github.com/Monserg/GolosBlockchain.git", :tag => "1.0.0"

end

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
