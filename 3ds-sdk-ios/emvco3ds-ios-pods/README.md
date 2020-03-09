# emvco3ds_ios_pods

# Frameworks
- Protocols
- (Modirum) SDK

# Swift and Xcode versions
- Swift 4.2 - Xcode 10.x compatible (Recommended; not suitable for Xcode 9.x)
- Swift 4.0 - Xcode 10.x compatible
- Swift 3.2 - Xcode 9.01 - Xcode 9.2 compatible (Not recommended. Supplied for backward compatibility only)

# Supported CPU Architectures
- X86 (Simulator)
- ARM (Device)

# Folder structure
--protocols_pod
---- swift32
---- swift40
---- swift42
--sdk_pod
---- swift32
---- swift40
------ arm
------ x86

The folder protocols_pod contains multiple frameworks compiled with different Swift versions. The protocol framework is a so called Fat framework, thus supporting both architectures (For simulator and for real devices)

The sdk_prod folder contains multiple frameworks, compiled with different Swift versions and for different architectures. To use the SDK with an iPhone simulator use the X86-variant or else use the ARM-variant.

## Installation
Create a reference in the Podfile that needs to use the protocol and SDK framework. Please refer to the folder structure, explained above. 

For example to refer to the Swift 4.0 SDK framework for a simulator you can include this with your Podfile:
pod 'MI_SDK_EMVCO_UL', :path => 'emvco3ds-ios-pods/sdk_pod/swift40/x86/sdk.podspec'

Or to refer to the Swift 4.2 protocols framework for a simulator or a device (iPhone) you can include this with your Podfile:
pod 'emvco3ds_protocols_ios', :path => 'emvco3ds-ios-pods/protocols_pod/swift42/protocols.podspec'