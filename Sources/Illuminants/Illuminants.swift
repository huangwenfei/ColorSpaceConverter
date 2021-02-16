//
//  Illuminants.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/24.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

infix operator ~ : AdditionPrecedence
public func ~ (two: Illuminant.TwoDegree, light: Illuminant.TwoLights) -> Illuminant {
    .two(light)
}

public func ~ (ten: Illuminant.TenDegree, light: Illuminant.TenLights) -> Illuminant {
    .ten(light)
}

public struct Illuminant: IlluminantProtocol {
    
    /// Class Properties
    /// ep: Self.degrees.two.lights(.d65)
    /// ep: .two(.d65)
    public static var `default`: Self = .two ~ .d65
    
    /// Properties
    public internal(set) var angle: Int = Degrees.two.angle
    public internal(set) var lamp: Lamp = .default
    
    /// Self -> Spectral
    public var canToSpectral: Bool {
        spectral != nil
    }
    
    public var spectral: SpectralIlluminant? {
        switch Degrees(rawValue: angle)! {
        case .two:
            switch TwoLights(rawValue: lamp.name)! {
            case .d55, .d75: return nil
            case .a:   return .two ~ .a
            case .b:   return .two ~ .b
            case .c:   return .two ~ .c
            case .d50: return .two ~ .d50
            case .d65: return .two ~ .d65
            case .e:   return .two ~ .e
            case .f2:  return .two ~ .f2
            case .f7:  return .two ~ .f7
            case .f11: return .two ~ .f11
            }
            
        case .ten:
            switch TenLights(rawValue: lamp.name)! {
            case .d55, .d75: return nil
            case .d50: return .ten ~ .d50
            case .d65: return .ten ~ .d65
            }
        }
    }
    
    // MARK: Inits
    public init() { }
    
    /// - Tag: long
    /// `let illuminant = Self.degrees.two.lights(.d65)`
    public static var degrees: DegreesGen {
        return DegreesGen()
    }
    
    /// - Tag: short
    /// `let illuminant = .two(.d65)`
    public static func two(_ lights: TwoLights) -> Self {
        return TwoLightsGen(Degrees.two.angle).lights(lights)
    }
    
    public static func ten(_ lights: TenLights) -> Self {
        return TenLightsGen(Degrees.ten.angle).lights(lights)
    }
    
    // MARK: Updates
    public mutating func updateAngle(_ angle: Degrees) {
        self.angle = angle.angle
    }
    
    public mutating func updateLamp(by name: String) {
        var xyz: Xyz?
        if angle == Degrees.two.angle {
            let new = TwoLights.init(rawValue: name)
            if let new = new { xyz = new.xyz }
        } else {
            let new = TenLights.init(rawValue: name)
            if let new = new { xyz = new.xyz }
        }
        if let new = xyz { lamp = Lamp(name, new) }
    }
    
    public mutating func updateTwoLamp(by name: TwoLights) {
        self.angle = Degrees.two.angle
        updateLamp(by: name.name)
    }
    
    public mutating func updateTenLamp(by name: TenLights) {
        self.angle = Degrees.ten.angle
        updateLamp(by: name.name)
    }
    
}

// MARK: - Extensions
// MARK: -

/// - Tag: Hashable
extension Illuminant: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(angle)
        hasher.combine(lamp)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.angle == rhs.angle
            && lhs.lamp == rhs.lamp
    }
    
}

/// - Tag: CustomStringConvertible, CustomDebugStringConvertible
extension Illuminant: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "[\(angle)˚, \(lamp)💡]"
    }
    
    public var debugDescription: String {
        return "\(Self.self): [angle: \(angle)˚, lamp: \(lamp)💡]"
    }
    
}

/// - Tag: Codable
extension Illuminant: Codable {
    
    enum CodingKeys: String, CodingKey {
        case angle
        case lamp
    }

    public init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        angle = try values.decode(Int.self, forKey: .angle)
        lamp = try values.decode(Lamp.self, forKey: .lamp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(angle, forKey: .angle)
        try container.encode(lamp, forKey: .lamp)
    }
    
}

// MARK: - Gen Heaper
// MARK: -

/// - Tag: Midle Helper
extension Illuminant {
    
    public struct DegreesGen {
        public init() { }
        
        public var two: TwoLightsGen {
            return TwoLightsGen(Degrees.two.angle)
        }
        
        public var ten: TenLightsGen {
            return TenLightsGen(Degrees.ten.angle)
        }
    }
    
    public class LightsGen {
        fileprivate var angle: Int = Degrees.two.angle
        fileprivate var lamp: Lamp = .default
        
        public init(_ angle: Int) {
            self.angle = angle
        }
        
        public func map() -> Illuminant {
            var v = Illuminant()
            v.angle = angle
            v.lamp = lamp
            return v
        }
    }
    
    public final class TwoLightsGen: LightsGen {
        public func lights(_ lights: TwoLights) -> Illuminant {
            lamp = Lamp(lights.name, lights.xyz)
            return self.map()
        }
    }
    
    public final class TenLightsGen: LightsGen {
        public func lights(_ lights: TenLights) -> Illuminant {
            lamp = Lamp(lights.name, lights.xyz)
            return self.map()
        }
    }
    
}

// MARK: - Structs
// MARK: -

/// - Tag: Light
extension Illuminant {
    
    public struct Lamp: Hashable, Codable,
        CustomStringConvertible, CustomDebugStringConvertible
    {
        
        public private(set) var name: String
        public private(set) var xyz: Xyz
        
        public static var `default`: Self = {
            let v = TwoLights.d65
            return Self(v.name, v.xyz)
        }()
        
        public init(_ name: String, _ xyz: Xyz) {
            self.name = name
            self.xyz = xyz
        }
        
        /// - Tag: CustomStringConvertible, CustomDebugStringConvertible
        public var description: String {
            return "[\(name), \(xyz)]"
        }
        
        public var debugDescription: String {
            return "\(Self.self) [name: \(name), xyz: \(xyz)]"
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(xyz)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
                && lhs.xyz == rhs.xyz
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case name
            case xyz
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let name = try values.decode(String.self, forKey: .name)
            let xyz = try values.decode(Xyz.self, forKey: .xyz)
            self.init(name, xyz)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(xyz, forKey: .xyz)
        }
    }
    
}

/// - Tag: Xyz
extension Illuminant {
    
    public struct Xyz: Hashable, Codable,
        CustomStringConvertible, CustomDebugStringConvertible
    {
        
        public internal(set) var x: Element
        public internal(set) var y: Element
        public internal(set) var z: Element
        
        public var toTuple: (x: Element, y: Element, z: Element) {
            return (x, y, z)
        }
        
        public var toArray: [Element] {
            return [x, y, z]
        }
        
        public static var `default` = Self(0, 0, 0)
        
        public init(_ x: Element, _ y: Element, _ z: Element) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        /// - Tag: CustomStringConvertible
        public var description: String {
            return "[\(x), \(y), \(z)]"
        }
        
        public var debugDescription: String {
            return "\(Self.self) [x: \(x), y: \(y), z: \(z)]"
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(x)
            hasher.combine(y)
            hasher.combine(z)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case x
            case y
            case z
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let x = try values.decode(Element.self, forKey: .x)
            let y = try values.decode(Element.self, forKey: .y)
            let z = try values.decode(Element.self, forKey: .z)
            self.init(x, y, z)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
            try container.encode(z, forKey: .z)
        }
    }
    
}

// MARK: - Enums
// MARK: -

/// - Tag: Degrees
extension Illuminant {
    
    public enum TwoDegree: Int, Hashable, Codable {
        case two = 2
        
        public var degress: Degrees {
            Degrees(rawValue: self.rawValue)!
        }
    }
    
    public enum TenDegree: Int, Hashable, Codable {
        case ten = 10
        
        public var degress: Degrees {
            Degrees(rawValue: self.rawValue)!
        }
    }
    
    public enum Degrees: Int, Hashable, Codable {
        case two = 2
        case ten = 10
        
        public var angle: Int { return rawValue }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(angle)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.angle == rhs.angle
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case value
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let v = try values.decode(Int.self, forKey: .value)
            self.init(rawValue: v)!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(rawValue, forKey: .value)
        }
    }
    
}

/// - Tag: Lights
extension Illuminant {
    
    public enum TwoLights: String, Hashable, Codable {
        case a
        case b
        case c
        case d50
        case d55
        case d65
        case d75
        case e
        case f2
        case f7
        case f11
        
        public var name: String { return rawValue }
        
        public var xyz: Xyz {
            switch self {
            case .a:   return Xyz(1.09850, 1.00000, 0.35585)
            case .b:   return Xyz(0.99072, 1.00000, 0.85223)
            case .c:   return Xyz(0.98074, 1.00000, 1.18232)
            case .d50: return Xyz(0.96422, 1.00000, 0.82521)
            case .d55: return Xyz(0.95682, 1.00000, 0.92149)
            case .d65: return Xyz(0.95047, 1.00000, 1.08883)
            case .d75: return Xyz(0.94972, 1.00000, 1.22638)
            case .e:   return Xyz(1.00000, 1.00000, 1.00000)
            case .f2:  return Xyz(0.99186, 1.00000, 0.67393)
            case .f7:  return Xyz(0.95041, 1.00000, 1.08747)
            case .f11: return Xyz(1.00962, 1.00000, 0.64350)
            }
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(xyz)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            guard lhs.name == rhs.name else { return false }
            return lhs.xyz == rhs.xyz
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case value
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let v = try values.decode(String.self, forKey: .value)
            self.init(rawValue: v)!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(rawValue, forKey: .value)
        }
    }
    
    public enum TenLights: String, Hashable {
        case d50
        case d55
        case d65
        case d75
        
        public var name: String { return rawValue }
        
        public var xyz: Xyz {
            switch self {
            case .d50: return Xyz(0.9672, 1.000, 0.8143)
            case .d55: return Xyz(0.958, 1.000, 0.9093)
            case .d65: return Xyz(0.9481, 1.000, 1.073)
            case .d75: return Xyz(0.94416, 1.000, 1.2064)
            }
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(xyz)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            guard lhs.name == rhs.name else { return false }
            return lhs.xyz == rhs.xyz
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case value
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let v = try values.decode(String.self, forKey: .value)
            self.init(rawValue: v)!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(rawValue, forKey: .value)
        }
    }
    
}
