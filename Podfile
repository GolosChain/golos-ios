# Uncomment the next line to define a global platform for your project
platform :ios, '9.3'
use_frameworks!

target 'Golos' do
    
    pod 'Down'
    pod 'MarkdownView'

    
    # A tool to enforce Swift style and conventions
    pod 'SwiftLint'
    
    pod 'IQKeyboardManagerSwift', '~> 5.0'

    # CoreBitcoin
#    pod 'CoreBitcoin', :podspec => 'https://raw.github.com/oleganza/CoreBitcoin/master/CoreBitcoin.podspec'

    # Distribution & Crash report
    pod 'Fabric', '~> 1.7'
    pod 'Crashlytics', '~> 3.10'
    
    # Firebase
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    
    # Design
    pod 'Tags', '~> 0.1'
    pod 'Kingfisher', '~> 4.10'
    pod 'SwiftTheme'
    pod 'SkeletonView'
    pod 'SnapKit', '~> 4.0'
    pod 'LayoutKit', '~> 7.0'
    pod 'Amplitude-iOS', '~> 4.0.4'
    pod 'SwiftGifOrigin', '~> 1.6.1'
    pod 'MXParallaxHeader', '~> 0.6'
    pod 'AlignedCollectionViewFlowLayout'
    
# Pods for golos-ios
#    pod 'GoloSwift', '~> 1.1'
    pod 'GoloSwift', :git => "https://github.com/GolosChain/GoloSwift.git"
#    pod 'GoloSwift', :git => "https://github.com/GolosChain/GoloSwift.git", :tag => "1.1.7"

end

pre_install do |installer|
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
