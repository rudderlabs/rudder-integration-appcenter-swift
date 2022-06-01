//
//  RSAdjustDestination.swift
//  RudderAppCenter
//
//  Created by Pallab Maiti on 27/03/22.
//

import Foundation
import Rudder
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

class RSAppCenterDestination: RSDestinationPlugin {
    let type = PluginType.destination
    let key = "App Center"
    var client: RSClient?
    var controller = RSController()
    var eventPriorityDict: [String: String]?
        
    func update(serverConfig: RSServerConfig, type: UpdateType) {
        guard type == .initial else { return }
        guard let appCenterConfig: RudderAppCenterConfig = serverConfig.getConfig(forPlugin: self) else {
            client?.log(message: "Failed to Initialize AppCenter Factory", logLevel: .warning)
            return
        }
        if !appCenterConfig.transmissionLevel.isEmpty, let interval = Int(appCenterConfig.transmissionLevel) {
            Analytics.transmissionInterval = UInt(interval) * 60
        }
        AppCenter.logLevel = getLogLevel(rsLogLevel: client?.configuration?.logLevel ?? .none)
        AppCenter.start(withAppSecret: appCenterConfig.appSecret, services: [Analytics.self])
        self.eventPriorityDict = appCenterConfig.eventPriorityMap
        client?.log(message: "Initializing AppCenter SDK", logLevel: .debug)
    }
    
    func track(message: TrackMessage) -> TrackMessage? {
        if let eventPriorityDict = eventPriorityDict, let flag = eventPriorityDict[message.event] {
            if flag == "Normal" {
                Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties), flags: .normal)
            } else if flag == "Critical" {
                Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties), flags: .critical)
            }
        } else {
            Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties))
        }
        return message
    }
    
    func screen(message: ScreenMessage) -> ScreenMessage? {
        Analytics.trackEvent("Viewed \(message.name) screen", withProperties: extractProperties(message.properties))
        return message
    }
}

// MARK: - Support methods

extension RSAppCenterDestination {
    func extractProperties(_ properties: [String: Any]?) -> [String: String]? {
        var params: [String: String]?
        if let properties = properties {
            params = [String: String]()
            for (key, value) in properties {
                params?[key] = "\(value)"
            }
        }
        return params
    }
    
    func getLogLevel(rsLogLevel: RSLogLevel) -> LogLevel {
        switch rsLogLevel {
        case .verbose:
            return .verbose
        case .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .warning
        case .error:
            return .error
        case .none:
            return .none
        }
    }
}

struct RudderAppCenterConfig: Codable {
    struct RSDictionary: Codable {
        let to: String?
        let from: String?
    }
    
    private let _appSecret: String?
    var appSecret: String {
        return _appSecret ?? ""
    }
    
    private let _transmissionLevel: String?
    var transmissionLevel: String {
        return _transmissionLevel ?? ""
    }
    
    private var _eventPriorityMap: [RSDictionary]?
    var eventPriorityMap: [String: String] {
        var eventPriorityMapDict = [String: String]()
        if let from: [String] = _eventPriorityMap?.map({String($0.from ?? "") }),
           let to: [String] = _eventPriorityMap?.map({String($0.to ?? "") }) {
            eventPriorityMapDict = Dictionary(uniqueKeysWithValues: zip(from, to))
        }
        return eventPriorityMapDict
    }
    
    enum CodingKeys: String, CodingKey {
        case _appSecret = "appSecret"
        case _transmissionLevel = "transmissionLevel"
        case _eventPriorityMap = "eventPriorityMap"
    }
}

@objc
public class RudderAppCenterDestination: RudderDestination {
    
    public override init() {
        super.init()
        plugin = RSAppCenterDestination()
    }
}
