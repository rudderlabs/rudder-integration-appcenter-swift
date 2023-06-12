source 'https://github.com/CocoaPods/Specs.git'
workspace 'RudderAppCenter.xcworkspace'
use_frameworks!
inhibit_all_warnings!
platform :ios, '13.0'

def shared_pods
    pod 'Rudder'
end

target 'RudderAppCenter' do
    project 'RudderAppCenter.xcodeproj'
    pod 'Rudder', '~> 2.0'
    pod 'AppCenter', '4.4.1'
end

target 'SampleAppObjC' do
    project 'Examples/SampleAppObjC/SampleAppObjC.xcodeproj'
    pod 'RudderAppCenter', :path => '.'
end

target 'SampleAppSwift' do
    project 'Examples/SampleAppSwift/SampleAppSwift.xcodeproj'
    pod 'RudderAppCenter', :path => '.'
end
