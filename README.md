<p align="center">
  <a href="https://rudderstack.com/">
    <img src="https://user-images.githubusercontent.com/59817155/121357083-1c571300-c94f-11eb-8cc7-ce6df13855c9.png">
  </a>
</p>

<p align="center"><b>The Customer Data Platform for Developers</b></p>

<p align="center">
  <a href="https://cocoapods.org/pods/RudderAppCenter">
    <img src="https://img.shields.io/cocoapods/v/RudderAppCenter.svg?style=flat">
    </a>
</p>

<p align="center">
  <b>
    <a href="https://rudderstack.com">Website</a>
    ·
    <a href="https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-ios-sdk/ios-v2/">Documentation</a>
    ·
    <a href="https://rudderstack.com/join-rudderstack-slack-community">Community Slack</a>
  </b>
</p>

---
# Integrating RudderStack iOS SDK with App Center

This repository contains the resources and assets required to integrate the [RudderStack iOS SDK](https://www.rudderstack.com/docs/stream-sources/rudderstack-sdk-integration-guides/rudderstack-ios-sdk/ios-v2/) with [App Center](https://appcenter.ms/).

For more information on configuring Firebase as a destination in RudderStack and the supported events and their mappings, refer to the [App Center documentation](https://www.rudderstack.com/docs/destinations/continuous-integration/appcenter/).

| Important: This device mode integration is supported for App Center v4.4.1 and above.|
| :---|

## Step 1: Integrate the SDK with App Center

1. Add [App Center](https://appcenter.ms/) as a destination in the [RudderStack dashboard](https://app.rudderstack.com/).
2. `RudderAppCenter` is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your `Podfile`:

```ruby
pod 'RudderAppCenter', '~> 1.0.0'
```
4. Run the `pod install` command.

## Step 2: Import the SDK

### Swift

```swift
import RudderAppCenter
```

### Objective C

```objectivec
@import RudderAppCenter;
```

## Step 3: Initialize the RudderStack client (`RSClient`)

Place the following code in your `AppDelegate` under the `didFinishLaunchingWithOptions` method:

### Swift

```swift
let config: RSConfig = RSConfig(writeKey: WRITE_KEY)
            .dataPlaneURL(DATA_PLANE_URL)
        
RSClient.sharedInstance().configure(with: config)
RSClient.sharedInstance().addDestination(RudderAppCenterDestination())
```

### Objective C

```objective-c
RSConfig *config = [[RSConfig alloc] initWithWriteKey:WRITE_KEY];
[config dataPlaneURL:DATA_PLANE_URL];

[[RSClient sharedInstance] configureWith:config];
[[RSClient sharedInstance] addDestination:[[RudderAppCenterDestination alloc] init]];
```

## Step 4: Send events

Follow the steps listed in the [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios/tree/master-v2#sending-events) repo to start sending events to Firebase.

## About RudderStack

RudderStack is the **customer data platform** for developers. With RudderStack, you can build and deploy efficient pipelines that collect customer data from every app, website, and SaaS platform, then activate your data in your warehouse, business, and marketing tools.

| Start building a better, warehouse-first CDP that delivers complete, unified data to every part of your customer data stack. Sign up for [RudderStack Cloud](https://app.rudderstack.com/signup?type=freetrial) today. |
| :---|

## Contact us

For queries on configuring or using this integration, start a conversation in our [Slack](https://rudderstack.com/join-rudderstack-slack-community) community.
