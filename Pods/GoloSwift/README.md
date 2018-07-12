# GoloSwift
<img align="right" src='https://github.com/GolosChain/GoloSwift/blob/master/GoloSwift/Resources/Media.xcassets/icon-itunes.imageset/icon-itunes%402x.png' width='128' height='128'/>

Our framework is written in Swift 4 and is designed to work with the blockchain [Golos.io](https://golos.io/)

- [x] 📱 iOS 10.0+


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

## Installation

[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](https://cocoapods.org/pods/GoloSwift)

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GoloSwift', '~> 1.1'
end
```

Then, run the following command in `Terminal`:

```
$ pod update 'GoloSwift'
```

## Quick start

### Basics

For start use framework in top of any files add next code:

```
import GoloSwift
```

Framework support 3 Build Configurations:

* Debug
* Development
* Release

In `Info.plist` file add next parameter:

<img src='https://github.com/GolosChain/GoloSwift/blob/master/GoloSwift/Resources/Media.xcassets/screenshot-plist.imageset/screenshot-plist.png'/>


### Initialization

In top of AppDelegate.swift file create a global constant for the instance of the class Broadcast:

```
let broadcast: Broadcast = Broadcast.shared
```

### Load data

```
// Create MethodAPIType
let methodAPIType = MethodAPIType.getAccounts(names: ["inertia"])

// API 'get_accounts'
broadcast.executeGET(byMethodAPIType: methodAPIType,
        onResult: { [weak self] result in
            Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
        },
        onError: { [weak self] errorAPI in
            Logger.log(message: "nresponse ErrorAPI = \(errorAPI.caseInfo.message)\n", event: .error)
        })
```

### Save data

```
// Create OperationType
let operationType: OperationAPIType = OperationAPIType.vote(fields: (voter: voter, author: author, permlink: permlink, weight: weight))

// POST Request
broadcast.executePOST(byOperationAPIType: operationType,
        onResult: { [weak self] result in
            Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
        },
        onError: { [weak self] errorAPI in
            Logger.log(message: "nresponse ErrorAPI = \(errorAPI.caseInfo.message)\n", event: .error)
        })
```

### Logger
Simple, pretty and powerful logger for android

Initialize:

```
Logger.log(message: "\nresponse Result = \(result)\n", event: .debug)
```

Output:
<img src='https://github.com/GolosChain/GoloSwift/blob/master/GoloSwift/Resources/Media.xcassets/screenshot-logger.imageset/screenshot-logger.png'/>


## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Starscream](https://github.com/daltoniam/Starscream) - Websockets in Swift for iOS and OSX
* [BeyovaJSON](https://github.com/Beyova/BeyovaJSON) - BeyovaJSON allows any json for Coadable in Swift 4
* [Locksmith](https://github.com/matthewpalmer/Locksmith) - A powerful, protocol-oriented library for working with the keychain in Swift
* [Localize-Swift](https://github.com/marmelroy/Localize-Swift) - Swift friendly localization and i18n with in-app language switching
* [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) - CryptoSwift is a growing collection of standard and secure cryptographic algorithms implemented in Swift
* [secp256k1.swift](https://github.com/Boilertalk/secp256k1.swift) - secp256k1 bindings for Swift


## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

For the versions available, see the [tags on this repository](https://github.com/GolosChain/GoloSwift/tags). 

## Authors

* **Monastyrskyi Sergey** - *Initial work* - [Monserg](https://github.com/Monserg)

See also the list of [contributors](https://github.com/GolosChain/GoloSwift/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/GolosChain/GoloSwift/blob/master/LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc
