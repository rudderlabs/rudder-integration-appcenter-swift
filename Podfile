source 'https://github.com/CocoaPods/Specs.git'
workspace 'RudderAppCenter.xcworkspace'
use_frameworks!
inhibit_all_warnings!
platform :ios, '13.0'

def shared_pods
    pod 'RudderStack', :path => '~/Documents/Rudder/RudderStack-Cocoa/'
end

target 'RudderAppCenter' do
    project 'RudderAppCenter.xcodeproj'
    shared_pods
    pod 'AppCenter' , '4.4.1'
end

target 'SampleAppObjC' do
    project 'Examples/SampleAppObjC/SampleAppObjC.xcodeproj'
    shared_pods
    pod 'RudderAppCenter', :path => '.'
end

target 'SampleAppSwift' do
    project 'Examples/SampleAppSwift/SampleAppSwift.xcodeproj'
    shared_pods
    pod 'RudderAppCenter', :path => '.'
end
