//
//  SpectralIlluminant.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/1/6.
//  Copyright © 2021 黄文飞. All rights reserved.
//

import Foundation

#if false
// MARK: SpectralIlluminantOverlap

public func ~ (two: Illuminant.TwoDegree, light: SpectralIlluminantOverlap.Lights) -> SpectralIlluminantOverlap {
    .two(light)
}

public func ~ (ten: Illuminant.TenDegree, light: SpectralIlluminantOverlap.Lights) -> SpectralIlluminantOverlap {
    .ten(light)
}

public struct SpectralIlluminantOverlap: IlluminantProtocol {
    
    public static var `default`: Self = .two ~ .d65
    
    /// Properties
    public private(set) var angle: Angle = .default
    public private(set) var lamp: Lamp = .default
    
    public var unoverlap: SpectralIlluminant {
        .init(angle: angle, lamp: lamp)
    }
    
    public typealias Angle = SpectralIlluminant.Angle
    public typealias Lamp = SpectralIlluminant.Lamp
    public typealias Degrees = SpectralIlluminant.Degrees
    
    public static func two(_ lights: Lights) -> Self {
        LightsGen(angle: .init(.two)).lights(lights)
    }
    
    public static func ten(_ lights: Lights) -> Self {
        LightsGen(angle: .init(.ten)).lights(lights)
    }
    
}

/// - Tag: Midle Helper
extension SpectralIlluminantOverlap {

    public final class LightsGen {
        fileprivate var angle: Angle
        
        public init(angle: Angle) {
            self.angle = angle
        }
        
        public func lights(_ lights: Lights) -> SpectralIlluminantOverlap {
            var v = SpectralIlluminantOverlap()
            v.angle = angle
            let light = lights.lights
            v.lamp = Lamp(light.name, light.values)
            return v
        }
    }
    
}

/// - Tag: Lights
extension SpectralIlluminantOverlap {
    
    public enum Lights: String {
        case a
        case b
        case c
        case d50
        case d65
        case e
        case f2
        case f7
        case f11
        
        public var lights: SpectralIlluminant.Lights {
            SpectralIlluminant.Lights(rawValue: self.rawValue)!
        }
    }
    
}
#endif

// MARK: - SpectralIlluminant

infix operator ~ : AdditionPrecedence
public func ~ (two: Illuminant.TwoDegree, light: SpectralIlluminant.Lights) -> SpectralIlluminant {
    .two(light)
}

public func ~ (ten: Illuminant.TenDegree, light: SpectralIlluminant.Lights) -> SpectralIlluminant {
    .ten(light)
}

public struct SpectralIlluminant: IlluminantProtocol {
    
    /// Class Properties
    /// ep: Self.degrees(.two).lights(.d65)
    /// ep: .two(.d65)
    public static var `default`: Self = .two ~ .d65
    
    /// Properties
    public internal(set) var angle: Angle = .default
    public internal(set) var lamp: Lamp = .default
    
    /// Self -> Normal
    public var canToNormal: Bool {
        normal != nil
    }
    
    public var normal: Illuminant? {
        switch Degrees(rawValue: angle.name)! {
        case .two:
            switch Lights(rawValue: lamp.name)! {
            case .blackbody: return nil
                
            case .a:   return .two ~ .a
            case .b:   return .two ~ .a
            case .c:   return .two ~ .c
            case .d50: return .two ~ .d50
            case .d65: return .two ~ .d65
            case .e:   return .two ~ .e
            case .f2:  return .two ~ .f2
            case .f7:  return .two ~ .f7
            case .f11: return .two ~ .f11
            }
            
        case .ten:
            switch Lights(rawValue: lamp.name)! {
            case .a, .b, .c, .e, .f2, .f7, .f11, .blackbody: return nil
                
            case .d50: return .ten ~ .d50
            case .d65: return .ten ~ .d65
            }
        }
    }
    
    // MARK: Inits
    public init() {  }
    
    fileprivate init(angle: Angle, lamp: Lamp) {
        self.angle = angle
        self.lamp = lamp
    }
    
    /// - Tag: Long
    /// `let illuminant = Self.degrees(.two).lights(.d65)`
    public static func degrees(_ degree: Degrees) -> LightsGen {
        return LightsGen(angle: .init(degree))
    }
    
    /// - Tag: short
    /// `let illuminant = .two(.d65)`
    public static func two(_ lights: Lights) -> Self {
        LightsGen(angle: .init(.two)).lights(lights)
    }
    
    public static func ten(_ lights: Lights) -> Self {
        LightsGen(angle: .init(.ten)).lights(lights)
    }
    
    // MARK: Updates
    public mutating func updateAngle(_ degree: Degrees) {
        self.angle = Angle(degree.name, degree.values)
    }
    
    public mutating func updateLamp(by name: String) {
        guard let light = Lights(rawValue: name) else { return }
        self.lamp = Lamp(light.name, light.values)
    }
    
}

// MARK: - Extensions
// MARK: -

/// - Tag: Hashable
extension SpectralIlluminant: Hashable {
    
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
extension SpectralIlluminant: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "[\(angle)˚, \(lamp)💡]"
    }
    
    public var debugDescription: String {
        return "\(Self.self): [angle: \(angle)˚, lamp: \(lamp)💡]"
    }
    
}

/// - Tag: Codable
extension SpectralIlluminant: Codable {
    
    enum CodingKeys: String, CodingKey {
        case angle
        case lamp
    }

    public init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        angle = try values.decode(Angle.self, forKey: .angle)
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
extension SpectralIlluminant {

    public final class LightsGen {
        fileprivate var angle: Angle
        
        public init(angle: Angle) {
            self.angle = angle
        }
        
        public func lights(_ lights: Lights) -> SpectralIlluminant {
            var v = SpectralIlluminant()
            v.angle = angle
            v.lamp = Lamp(lights.name, lights.values)
            return v
        }
    }
    
}

// MARK: - Structs
// MARK: -
 
/// - Tag: Degree
extension SpectralIlluminant {
    
    public struct Angle: Hashable, Codable,
        CustomStringConvertible, CustomDebugStringConvertible
    {
        
        public private(set) var name: String
        public private(set) var values: Xyz
        
        public static var `default`: Self = {
            let v = Degrees.two
            return Self(v.name, v.values)
        }()
        
        public init(_ degrees: Degrees) {
            self.name = degrees.name
            self.values = degrees.values
        }
        
        public init(_ name: String, _ values: Xyz) {
            self.name = name
            self.values = values
        }
        
        /// - Tag: CustomStringConvertible, CustomDebugStringConvertible
        public var description: String {
            return "[\(name), \(values)]"
        }
        
        public var debugDescription: String {
            return "\(Self.self) [name: \(name), xyz: \(values)]"
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(values)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
                && lhs.values == rhs.values
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case name
            case values
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let name = try values.decode(String.self, forKey: .name)
            let xyz = try values.decode(Xyz.self, forKey: .values)
            self.init(name, xyz)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(values, forKey: .values)
        }
        
    }
    
}

extension SpectralIlluminant {
    
    public struct Xyz: Hashable, Codable,
        CustomStringConvertible, CustomDebugStringConvertible
    {
        
        public internal(set) var x: [Element]
        public internal(set) var y: [Element]
        public internal(set) var z: [Element]
        
        public init(x: [Element], y: [Element], z: [Element]) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        public var toTuple: (x: [Element], y: [Element], z: [Element]) {
            return (x, y, z)
        }
        
        public var toArray: [Element] {
            return [x, y, z].flatMap { $0 }
        }
        
        public static var `default` = Self(x: [0], y: [0], z: [0])
        
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
            let x = try values.decode([Element].self, forKey: .x)
            let y = try values.decode([Element].self, forKey: .y)
            let z = try values.decode([Element].self, forKey: .z)
            self.init(x: x, y: y, z: z)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
            try container.encode(z, forKey: .z)
        }
    }
    
}

/// - Tag: Light
extension SpectralIlluminant {
    
    public struct Lamp: Hashable, Codable,
        CustomStringConvertible, CustomDebugStringConvertible
    {
        
        public var name: String
        public var values: [Element]
        
        public static var `default`: Self = {
            let v = Lights.d50
            return Self(v.name, v.values)
        }()
        
        public init(_ name: String, _ values: [Element]) {
            self.name = name
            self.values = values
        }
        
        /// - Tag: CustomStringConvertible, CustomDebugStringConvertible
        public var description: String {
            return "[\(name), \(values)]"
        }
        
        public var debugDescription: String {
            return "\(Self.self) [name: \(name), xyz: \(values)]"
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(values)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
                && lhs.values == rhs.values
        }
        
        /// - Tag: Codable
        enum CodingKeys: String, CodingKey {
            case name
            case values
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let name = try values.decode(String.self, forKey: .name)
            let xyz = try values.decode([Element].self, forKey: .values)
            self.init(name, xyz)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(values, forKey: .values)
        }
    }
    
}


// MARK: - Enums
// MARK: -

/// - Tag: Degrees
extension SpectralIlluminant {
    
    public enum Degrees: String, Hashable, Codable {
        case two
        case ten
        
        public var name: String { return rawValue }
        
        public var values: Xyz {
            switch self {
            case .two: return Self.degree2
            case .ten: return Self.degree10
            }
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.name == rhs.name
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

extension SpectralIlluminant.Degrees {
    
    fileprivate static var degree2 = SpectralIlluminant.Xyz(
        x: [
            0.000000000000,
            0.000000000000,
            0.000129900000,
            0.000414900000,
            0.001368000000,
            0.004243000000,
            0.014310000000,
            0.043510000000,
            0.134380000000,
            0.283900000000,
            0.348280000000,
            0.336200000000,
            0.290800000000,
            0.195360000000,
            0.095640000000,
            0.032010000000,
            0.004900000000,
            0.009300000000,
            0.063270000000,
            0.165500000000,
            0.290400000000,
            0.433449900000,
            0.594500000000,
            0.762100000000,
            0.916300000000,
            1.026300000000,
            1.062200000000,
            1.002600000000,
            0.854449900000,
            0.642400000000,
            0.447900000000,
            0.283500000000,
            0.164900000000,
            0.087400000000,
            0.046770000000,
            0.022700000000,
            0.011359160000,
            0.005790346000,
            0.002899327000,
            0.001439971000,
            0.000690078600,
            0.000332301100,
            0.000166150500,
            0.000083075270,
            0.000041509940,
            0.000020673830,
            0.000010253980,
            0.000005085868,
            0.000002522525,
            0.000001251141
        ],
        y: [
            0.000000000000,
            0.000000000000,
            0.000003917000,
            0.000012390000,
            0.000039000000,
            0.000120000000,
            0.000396000000,
            0.001210000000,
            0.004000000000,
            0.011600000000,
            0.023000000000,
            0.038000000000,
            0.060000000000,
            0.090980000000,
            0.139020000000,
            0.208020000000,
            0.323000000000,
            0.503000000000,
            0.710000000000,
            0.862000000000,
            0.954000000000,
            0.994950100000,
            0.995000000000,
            0.952000000000,
            0.870000000000,
            0.757000000000,
            0.631000000000,
            0.503000000000,
            0.381000000000,
            0.265000000000,
            0.175000000000,
            0.107000000000,
            0.061000000000,
            0.032000000000,
            0.017000000000,
            0.008210000000,
            0.004102000000,
            0.002091000000,
            0.001047000000,
            0.000520000000,
            0.000249200000,
            0.000120000000,
            0.000060000000,
            0.000030000000,
            0.000014990000,
            0.000007465700,
            0.000003702900,
            0.000001836600,
            0.000000910930,
            0.000000451810
        ],
        z: [
            0.000000000000,
            0.000000000000,
            0.000606100000,
            0.001946000000,
            0.006450001000,
            0.020050010000,
            0.067850010000,
            0.207400000000,
            0.645600000000,
            1.385600000000,
            1.747060000000,
            1.772110000000,
            1.669200000000,
            1.287640000000,
            0.812950100000,
            0.465180000000,
            0.272000000000,
            0.158200000000,
            0.078249990000,
            0.042160000000,
            0.020300000000,
            0.008749999000,
            0.003900000000,
            0.002100000000,
            0.001650001000,
            0.001100000000,
            0.000800000000,
            0.000340000000,
            0.000190000000,
            0.000049999990,
            0.000020000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000
        ]
    )
    
    fileprivate static var degree10 = SpectralIlluminant.Xyz(
        x: [
            0.000000000000,
            0.000000000000,
            0.000000122200,
            0.000005958600,
            0.000159952000,
            0.002361600000,
            0.019109700000,
            0.084736000000,
            0.204492000000,
            0.314679000000,
            0.383734000000,
            0.370702000000,
            0.302273000000,
            0.195618000000,
            0.080507000000,
            0.016172000000,
            0.003816000000,
            0.037465000000,
            0.117749000000,
            0.236491000000,
            0.376772000000,
            0.529826000000,
            0.705224000000,
            0.878655000000,
            1.014160000000,
            1.118520000000,
            1.123990000000,
            1.030480000000,
            0.856297000000,
            0.647467000000,
            0.431567000000,
            0.268329000000,
            0.152568000000,
            0.081260600000,
            0.040850800000,
            0.019941300000,
            0.009576880000,
            0.004552630000,
            0.002174960000,
            0.001044760000,
            0.000508258000,
            0.000250969000,
            0.000126390000,
            0.000064525800,
            0.000033411700,
            0.000017611500,
            0.000009413630,
            0.000005093470,
            0.000002795310,
            0.000001553140
        ],
        y: [
            0.000000000000,
            0.000000000000,
            0.000000013398,
            0.000000651100,
            0.000017364000,
            0.000253400000,
            0.002004400000,
            0.008756000000,
            0.021391000000,
            0.038676000000,
            0.062077000000,
            0.089456000000,
            0.128201000000,
            0.185190000000,
            0.253589000000,
            0.339133000000,
            0.460777000000,
            0.606741000000,
            0.761757000000,
            0.875211000000,
            0.961988000000,
            0.991761000000,
            0.997340000000,
            0.955552000000,
            0.868934000000,
            0.777405000000,
            0.658341000000,
            0.527963000000,
            0.398057000000,
            0.283493000000,
            0.179828000000,
            0.107633000000,
            0.060281000000,
            0.031800400000,
            0.015905100000,
            0.007748800000,
            0.003717740000,
            0.001768470000,
            0.000846190000,
            0.000407410000,
            0.000198730000,
            0.000098428000,
            0.000049737000,
            0.000025486000,
            0.000013249000,
            0.000007012800,
            0.000003764730,
            0.000002046130,
            0.000001128090,
            0.000000629700
        ],
        z: [
            0.000000000000,
            0.000000000000,
            0.000000535027,
            0.000026143700,
            0.000704776000,
            0.010482200000,
            0.086010900000,
            0.389366000000,
            0.972542000000,
            1.553480000000,
            1.967280000000,
            1.994800000000,
            1.745370000000,
            1.317560000000,
            0.772125000000,
            0.415254000000,
            0.218502000000,
            0.112044000000,
            0.060709000000,
            0.030451000000,
            0.013676000000,
            0.003988000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000,
            0.000000000000
        ]
    )
    
}

/// - Tag: Lights
extension SpectralIlluminant {
    
    public enum Lights: String, Hashable, Codable {
        case a
        case b
        case c
        case d50
        case d65
        case e
        case f2
        case f7
        case f11
        case blackbody
        
        public var name: String { return rawValue }
        
        public var values: [Element] {
            switch self {
            case .a:   return Self.lightA
            case .b:   return Self.lightB
            case .c:   return Self.lightC
            case .d50: return Self.lightD50
            case .d65: return Self.lightD65
            case .e:   return Self.lightE
            case .f2:  return Self.lightF2
            case .f7:  return Self.lightF7
            case .f11: return Self.lightF11
            case .blackbody: return Self.lightBlackbody
            }
        }
        
        /// - Tag: Hashable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(values)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            guard lhs.name == rhs.name else { return false }
            return lhs.values == rhs.values
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

extension SpectralIlluminant.Lights {
    
    fileprivate static var lightA: [SpectralIlluminant.Element] = [
        3.59,
        4.75,
        6.15,
        7.83,
        9.80,
        12.09,
        14.72,
        17.69,
        21.01,
        24.68,
        28.71,
        33.10,
        37.82,
        42.88,
        48.25,
        53.92,
        59.87,
        66.07,
        72.50,
        79.14,
        85.95,
        92.91,
        100.00,
        107.18,
        114.43,
        121.72,
        129.03,
        136.33,
        143.60,
        150.81,
        157.95,
        164.99,
        171.92,
        178.72,
        185.38,
        191.88,
        198.20,
        204.34,
        210.29,
        216.04,
        221.58,
        226.91,
        232.02,
        236.91,
        241.57,
        246.01,
        250.21,
        254.19,
        257.95,
        261.47
    ]
    
    fileprivate static var lightB: [SpectralIlluminant.Element] = [
        2.40,
        5.60,
        9.60,
        15.20,
        22.40,
        31.30,
        41.30,
        52.10,
        63.20,
        73.10,
        80.80,
        85.40,
        88.30,
        92.00,
        95.20,
        96.50,
        94.20,
        90.70,
        89.50,
        92.20,
        96.90,
        101.00,
        102.80,
        102.60,
        101.00,
        99.20,
        98.00,
        98.50,
        99.70,
        101.00,
        102.20,
        103.90,
        105.00,
        104.90,
        103.90,
        101.60,
        99.10,
        96.20,
        92.90,
        89.40,
        86.90,
        85.20,
        84.70,
        85.40,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    ]
    
    fileprivate static var lightC: [SpectralIlluminant.Element] = [
        2.70,
        7.00,
        12.90,
        21.40,
        33.00,
        47.40,
        63.30,
        80.60,
        98.10,
        112.40,
        121.50,
        124.00,
        123.10,
        123.80,
        123.90,
        120.70,
        112.10,
        102.30,
        96.90,
        98.00,
        102.10,
        105.20,
        105.30,
        102.30,
        97.80,
        93.20,
        89.70,
        88.40,
        88.10,
        88.00,
        87.80,
        88.20,
        87.90,
        86.30,
        84.00,
        80.20,
        76.30,
        72.40,
        68.30,
        64.40,
        61.50,
        59.20,
        58.10,
        58.20,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    ]
    
    fileprivate static var lightD50: [SpectralIlluminant.Element] = [
        17.92,
        20.98,
        23.91,
        25.89,
        24.45,
        29.83,
        49.25,
        56.45,
        59.97,
        57.76,
        74.77,
        87.19,
        90.56,
        91.32,
        95.07,
        91.93,
        95.70,
        96.59,
        97.11,
        102.09,
        100.75,
        102.31,
        100.00,
        97.74,
        98.92,
        93.51,
        97.71,
        99.29,
        99.07,
        95.75,
        98.90,
        95.71,
        98.24,
        103.06,
        99.19,
        87.43,
        91.66,
        92.94,
        76.89,
        86.56,
        92.63,
        78.27,
        57.72,
        82.97,
        78.31,
        79.59,
        73.44,
        63.95,
        70.81,
        74.48
    ]
    
    fileprivate static var lightD65: [SpectralIlluminant.Element] = [
        39.90,
        44.86,
        46.59,
        51.74,
        49.92,
        54.60,
        82.69,
        91.42,
        93.37,
        86.63,
        104.81,
        116.96,
        117.76,
        114.82,
        115.89,
        108.78,
        109.33,
        107.78,
        104.78,
        107.68,
        104.40,
        104.04,
        100.00,
        96.34,
        95.79,
        88.69,
        90.02,
        89.61,
        87.71,
        83.30,
        83.72,
        80.05,
        80.24,
        82.30,
        78.31,
        69.74,
        71.63,
        74.37,
        61.62,
        69.91,
        75.11,
        63.61,
        46.43,
        66.83,
        63.40,
        64.32,
        59.47,
        51.97,
        57.46,
        60.33
    ]
    
    fileprivate static var lightE: [SpectralIlluminant.Element] = [
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00,
        100.00
    ]
    
    fileprivate static var lightF2: [SpectralIlluminant.Element] = [
        0.00,
        0.00,
        0.00,
        0.00,
        1.18,
        1.84,
        3.44,
        3.85,
        4.19,
        5.06,
        11.81,
        6.63,
        7.19,
        7.54,
        7.65,
        7.62,
        7.28,
        7.05,
        7.16,
        8.04,
        10.01,
        16.64,
        16.16,
        18.62,
        22.79,
        18.66,
        16.54,
        13.80,
        10.95,
        8.40,
        6.31,
        4.68,
        3.45,
        2.55,
        1.89,
        1.53,
        1.10,
        0.88,
        0.68,
        0.56,
        0.51,
        0.47,
        0.46,
        0.40,
        0.27,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    ]
    
    fileprivate static var lightF7: [SpectralIlluminant.Element] = [
        0.00,
        0.00,
        0.00,
        0.00,
        2.56,
        3.84,
        6.15,
        7.37,
        7.71,
        9.15,
        17.52,
        12.00,
        13.08,
        13.71,
        13.95,
        13.82,
        13.43,
        13.08,
        12.78,
        12.44,
        12.26,
        17.05,
        12.58,
        12.83,
        16.75,
        12.67,
        12.19,
        11.60,
        11.12,
        10.76,
        10.11,
        10.02,
        9.87,
        7.27,
        5.83,
        5.04,
        4.12,
        3.46,
        2.73,
        2.25,
        1.90,
        1.62,
        1.45,
        1.17,
        0.81,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    ]
    
    fileprivate static var lightF11: [SpectralIlluminant.Element] = [
        0.00,
        0.00,
        0.00,
        0.00,
        0.91,
        0.46,
        1.29,
        1.59,
        2.46,
        4.49,
        12.13,
        7.19,
        6.72,
        5.46,
        5.66,
        14.96,
        4.72,
        1.47,
        0.89,
        1.18,
        39.59,
        32.61,
        2.83,
        1.67,
        11.28,
        12.73,
        7.33,
        55.27,
        13.18,
        12.26,
        2.07,
        3.58,
        2.48,
        1.54,
        1.46,
        2.00,
        1.35,
        5.58,
        0.57,
        0.23,
        0.24,
        0.20,
        0.32,
        0.16,
        0.09,
        0.00,
        0.00,
        0.00,
        0.00,
        0.00
    ]

    fileprivate static var lightBlackbody: [SpectralIlluminant.Element] = [
        43.36,
        47.77,
        52.15,
        56.44,
        60.62,
        64.65,
        68.51,
        72.18,
        75.63,
        78.87,
        81.87,
        84.63,
        87.16,
        89.44,
        91.48,
        93.29,
        94.87,
        96.23,
        97.37,
        98.31,
        99.05,
        99.61,
        100.00,
        100.22,
        100.29,
        100.21,
        100.00,
        99.67,
        99.22,
        98.67,
        98.02,
        97.28,
        96.47,
        95.58,
        94.63,
        93.62,
        92.56,
        91.45,
        90.30,
        89.12,
        87.91,
        86.67,
        85.42,
        84.15,
        82.86,
        81.56,
        80.26,
        78.95,
        77.64,
        76.33
    ]
    
}
