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
        if let destination = serverConfig.getDestination(by: key), let config = destination.config?.dictionaryValue {
            if let appSecret = config["appSecret"] as? String {
                if let transmissionLevel = config["transmissionLevel"] as? String, !transmissionLevel.isEmpty, let interval = Int(transmissionLevel) {
                    Analytics.transmissionInterval = UInt(interval) * 60
                }
                AppCenter.logLevel = getLogLevel(rsLogLevel: client?.configuration.logLevel ?? .none)
                AppCenter.start(withAppSecret: appSecret, services: [Analytics.self])
                if let eventPriorityList = config["eventPriorityMap"] as? [[String: String]] {
                    var eventPriorityDict = [String: String]()
                    for eventPriority in eventPriorityList {
                        if let from = eventPriority["from"], let to = eventPriority["to"], !from.isEmpty, !to.isEmpty {
                            eventPriorityDict[from] = to
                        }
                    }
                    if !eventPriorityDict.isEmpty {
                        self.eventPriorityDict = eventPriorityDict
                    }
                }
            }
        }
    }
    
    func identify(message: IdentifyMessage) -> IdentifyMessage? {
        client?.log(message: "MessageType is not supported", logLevel: .warning)
        return message
    }
    
    func track(message: TrackMessage) -> TrackMessage? {
        if let eventPriorityDict = eventPriorityDict {
            if let flag = eventPriorityDict[message.event] {
                if flag == "Normal" {
                    Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties), flags: .normal)
                } else {
                    Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties), flags: .critical)
                }
            } else {
                Analytics.trackEvent(message.event, withProperties: extractProperties(message.properties))
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
    
    func group(message: GroupMessage) -> GroupMessage? {
        client?.log(message: "MessageType is not supported", logLevel: .warning)
        return message
    }
    
    func alias(message: AliasMessage) -> AliasMessage? {
        client?.log(message: "MessageType is not supported", logLevel: .warning)
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
                switch value {
                case let v as String:
                    params?[key] = v
                case let v as Int:
                    params?[key] = "\(v)"
                case let v as Double:
                    params?[key] = "\(v)"
                default:
                    params?[key] = "\(value)"
                }
            }
        }
        if params?.isEmpty == false {
            return params
        }
        return nil
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

@objc
public class RudderAppCenterDestination: RudderDestination {
    
    public override init() {
        super.init()
        plugin = RSAppCenterDestination()
    }
}
