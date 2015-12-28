//
//  iDevices.swift
//  DeviceInfo
//
//  Created by abdul karim on 26/12/15.
//  Copyright © 2015 dhlabs. All rights reserved.
//

import class UIKit.UIDevice
import struct Darwin.utsname
import func Darwin.uname
import func Darwin.round
import func Darwin.getenv

public enum Device {
    #if os(iOS)
    case iPodTouch5
    case iPodTouch6
    
    case iPhone4
    case iPhone4S
    case iPhone5
    case iPhone5C
    case iPhone5S
    case iPhone6
    case iPhone6Plus
    case iPhone6S
    case iPhone6SPlus
    
    case iPad2
    case iPad3
    case iPad4
    
    case iPadAir
    case iPadAir2
    
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4

    case iPadPro
    
    #elseif os(tvOS)
    case AppleTV4
    #endif
    indirect case Simulator(Device)
    case UnknownDevice(String)
    
    public init() {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapIdentifierToDevice(identifier: String) -> Device {
            #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return iPodTouch5
                case "iPod7,1":                                 return iPodTouch6
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return iPhone4
                case "iPhone4,1":                               return iPhone4S
                case "iPhone5,1", "iPhone5,2":                  return iPhone5
                case "iPhone5,3", "iPhone5,4":                  return iPhone5C
                case "iPhone6,1", "iPhone6,2":                  return iPhone5S
                case "iPhone7,2":                               return iPhone6
                case "iPhone7,1":                               return iPhone6Plus
                case "iPhone8,1":                               return iPhone6S
                case "iPhone8,2":                               return iPhone6SPlus
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return iPad2
                case "iPad3,1", "iPad3,2", "iPad3,3":           return iPad3
                case "iPad3,4", "iPad3,5", "iPad3,6":           return iPad4
                case "iPad4,1", "iPad4,2", "iPad4,3":           return iPadAir
                case "iPad5,3", "iPad5,4":                      return iPadAir2
                case "iPad2,5", "iPad2,6", "iPad2,7":           return iPadMini
                case "iPad4,4", "iPad4,5", "iPad4,6":           return iPadMini2
                case "iPad4,7", "iPad4,8", "iPad4,9":           return iPadMini3
                case "iPad5,1", "iPad5,2":                      return iPadMini4
                case "iPad6,7", "iPad6,8":                      return iPadPro
                case "i386", "x86_64":                          return Simulator(mapIdentifierToDevice(String(UTF8String: getenv("SIMULATOR_MODEL_IDENTIFIER"))!))
                default:                                        return UnknownDevice(identifier)
                }
            #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3":                              return AppleTV4
                case "i386", "x86_64":                          return Simulator(mapIdentifierToDevice(String(UTF8String: getenv("SIMULATOR_MODEL_IDENTIFIER"))!))
                default:                                        return UnknownDevice(identifier)
                }
            #endif
        }
        self = mapIdentifierToDevice(identifier)
    }
    
    #if os(iOS)
    public static var allPods: [Device] {
        return [.iPodTouch5, .iPodTouch6]
    }
    
    /// All iPhones
    public static var allPhones: [Device] {
        return [.iPhone4, iPhone4S, .iPhone5, .iPhone5S, .iPhone6, .iPhone6Plus, .iPhone6S, .iPhone6SPlus]
    }
    
    /// All iPads
    public static var allPads: [Device] {
        return [.iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro]
    }
    
    /// All simulator iPods
    public static var allSimulatorPods: [Device] {
        return allPods.map(Device.Simulator)
    }
    
    /// All simulator iPhones
    public static var allSimulatorPhones: [Device] {
        return allPhones.map(Device.Simulator)
    }
    
    /// All simulator iPads
    public static var allSimulatorPads: [Device] {
        return allPads.map(Device.Simulator)
    }
    
    /// Return whether the device is an iPod (real or simulator)
    public var isPod: Bool {
        return self.isOneOf(Device.allPods) || self.isOneOf(Device.allSimulatorPods)
    }
    
    /// Return whether the device is an iPhone (real or simulator)
    public var isPhone: Bool {
        return self.isOneOf(Device.allPhones) || self.isOneOf(Device.allSimulatorPhones)
    }
    
    /// Return whether the device is an iPad (real or simulator)
    public var isPad: Bool {
        return self.isOneOf(Device.allPads) || self.isOneOf(Device.allSimulatorPads)
    }
    
    #elseif os(tvOS)
    /// All TVs
    public static var allTVs: [Device] {
    return [.AppleTV4]
    }
    
    /// All simulator TVs
    public static var allSimulatorTVs: [Device] {
    return allTVs.map(Device.Simulator)
    }
    #endif
    
    /// All real devices (i.e. all devices except for all simulators)
    public static var allRealDevices: [Device] {
        #if os(iOS)
            return allPods + allPhones + allPads
        #elseif os(tvOS)
            return allTVs
        #endif
    }
    
    /// All simulators
    public static var allSimulators: [Device] {
        return allRealDevices.map(Device.Simulator)
    }
    
    /**
     This method saves you in many cases from the need of updating your code with every new device.
     Most uses for an enum like this are the following:
     
     ```
     switch Device() {
     case .iPodTouch5, .iPodTouch6: callMethodOnIPods()
     case .iPhone4, iPhone4S, .iPhone5, .iPhone5S, .iPhone6, .iPhone6Plus, .iPhone6S, .iPhone6SPlus: callMethodOnIPhones()
     case .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro: callMethodOnIPads()
     default: break
     }
     ```
     This code can now be replaced with
     
     ```
     let device = Device()
     if device.isOneOf(Device.allPods) {
     callMethodOnIPods()
     } else if device.isOneOf(Device.allPhones) {
     callMethodOnIPhones()
     } else if device.isOneOf(Device.allPads) {
     callMethodOnIPads()
     }
     ```
     
     - parameter devices: An array of devices.
     
     - returns: Returns whether the current device is one of the passed in ones.
     */
    public func isOneOf(devices: [Device]) -> Bool {
        return devices.contains(self)
    }
    
    /// The style of interface to use on the current device.
    /// This is pretty useless right now since it does not add any further functionality to the existing [UIUserInterfaceIdiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/#//apple_ref/c/tdef/UIUserInterfaceIdiom) enum.
    public enum UserInterfaceIdiom {
        
        /// The user interface should be designed for iPhone and iPod touch.
        case Phone
        /// The user interface should be designed for iPad.
        case Pad
        /// The user interface should be designed for TV
        case TV
        /// Used when an object has a trait collection, but it is not in an environment yet. For example, a view that is created, but not put into a view hierarchy.
        case Unspecified
        
        private init() {
            switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Pad:          self = .Pad
            case .Phone:        self = .Phone
            case .TV:           self = .TV
            case .Unspecified:  self = .Unspecified
            }
        }
        
    }
    
    /// The name identifying the device (e.g. "Eric' iPhone").
    public var name: String {
        return UIDevice.currentDevice().name
    }
    
    /// The name of the operating system running on the device represented by the receiver (e.g. "iPhone OS" or "tvOS").
    public var systemName: String {
        return UIDevice.currentDevice().systemName
    }
    
    /// The current version of the operating system (e.g. 7.4 or 9.2).
    public var systemVersion: String {
        return UIDevice.currentDevice().systemVersion
    }
    
    /// The model of the device (e.g. "iPhone" or "iPod Touch").
    public var model: String {
        return UIDevice.currentDevice().model
    }
    
    /// The model of the device as a localized string.
    public var localizedModel: String {
        return UIDevice.currentDevice().localizedModel
    }
    
    /// The model of the device including the generation (if != 1).
    @available(*, deprecated=0.2.0, obsoleted=0.3.0, message="Use `description` instead.")
    public var detailedModel: String {
        return description
    }
    
}

// MARK: - CustomStringConvertible
extension Device: CustomStringConvertible {
    
    public var description: String {
        #if os(iOS)
            switch self {
            case .iPodTouch5:                   return "iPod Touch 5"
            case .iPodTouch6:                   return "iPod Touch 6"
            case .iPhone4:                      return "iPhone 4"
            case .iPhone4S:                     return "iPhone 4s"
            case .iPhone5:                      return "iPhone 5"
            case .iPhone5C:                     return "iPhone 5c"
            case .iPhone5S:                     return "iPhone 5s"
            case .iPhone6:                      return "iPhone 6"
            case .iPhone6Plus:                  return "iPhone 6 Plus"
            case .iPhone6S:                     return "iPhone 6s"
            case .iPhone6SPlus:                 return "iPhone 6s Plus"
            case .iPad2:                        return "iPad 2"
            case .iPad3:                        return "iPad 3"
            case .iPad4:                        return "iPad 4"
            case .iPadAir:                      return "iPad Air"
            case .iPadAir2:                     return "iPad Air 2"
            case .iPadMini:                     return "iPad Mini"
            case .iPadMini2:                    return "iPad Mini 2"
            case .iPadMini3:                    return "iPad Mini 3"
            case .iPadMini4:                    return "iPad Mini 4"
            case .iPadPro:                      return "iPad Pro"
            case .Simulator(let model):         return "Simulator (\(model))"
            case .UnknownDevice(let identifier):return identifier
            }
        #elseif os(tvOS)
            switch self {
            case .AppleTV4:                     return "Apple TV 4"
            case .Simulator(let model):         return "Simulator (\(model))"
            case .UnknownDevice(let identifier):return identifier
            }
        #endif
    }
}

// MARK: - Equatable
extension Device: Equatable {}

public func ==(lhs: Device, rhs: Device) -> Bool {
    return lhs.description == rhs.description
}

#if os(iOS)
    // MARK: - Battery
    extension Device {
        /**
         This enum describes the state of the battery.
         
         - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
         - Charging:  The device is plugged into power and the battery is less than 100% charged.
         - Unplugged: The device is not plugged into power; the battery is discharging.
         */
        public enum BatteryState: CustomStringConvertible, Equatable {
            /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
            case Full
            /// The device is plugged into power and the battery is less than 100% charged.
            /// The associated value is in percent (0-100).
            case Charging(Int)
            /// The device is not plugged into power; the battery is discharging.
            /// The associated value is in percent (0-100).
            case Unplugged(Int)
            
            private init() {
                UIDevice.currentDevice().batteryMonitoringEnabled = true
                let batteryLevel = Int(round(UIDevice.currentDevice().batteryLevel * 100))  // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
                // but maybe that changes in the future.
                switch UIDevice.currentDevice().batteryState {
                case .Charging: self = .Charging(batteryLevel)
                case .Full:     self = .Full
                case .Unplugged:self = .Unplugged(batteryLevel)
                case .Unknown:  self = .Full    // Should never happen since `batteryMonitoring` is enabled.
                }
                UIDevice.currentDevice().batteryMonitoringEnabled = false
            }
            
            public var description: String {
                switch self {
                case .Charging(let batteryLevel):   return "Battery level: \(batteryLevel)%, device is plugged in."
                case .Full:                         return "Battery level: 100 % (Full), device is plugged in."
                case .Unplugged(let batteryLevel):  return "Battery level: \(batteryLevel)%, device is unplugged."
                }
            }
            
        }
        
        /// The state of the battery
        public var batteryState: BatteryState {
            return BatteryState()
        }
        
        /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
        public var batteryLevel: Int {
            switch BatteryState() {
            case .Charging(let value):  return value
            case .Full:                 return 100
            case .Unplugged(let value): return value
            }
        }
        
    }
    
    // MARK: - Device.Batterystate: Comparable
    extension Device.BatteryState: Comparable {}
    
    public func ==(lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
        return lhs.description == rhs.description
    }
    
    public func <(lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
        switch (lhs, rhs) {
        case (.Full, _):                                            return false                // return false (even if both are `.Full` -> they are equal)
        case (_, .Full):                                            return true                 // lhs is *not* `.Full`, rhs is
        case (.Charging(let lhsLevel), .Charging(let rhsLevel)):    return lhsLevel < rhsLevel
        case (.Charging(let lhsLevel), .Unplugged(let rhsLevel)):   return lhsLevel < rhsLevel
        case (.Unplugged(let lhsLevel), .Charging(let rhsLevel)):   return lhsLevel < rhsLevel
        case (.Unplugged(let lhsLevel), .Unplugged(let rhsLevel)):  return lhsLevel < rhsLevel
        default:                                                    return false                // compiler won't compile without it, though it cannot happen
        }
    }
#endif

