//
//  ColorProtocol.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

// MARK: AnyColorable
public struct AnyColorable {
    
    /// The value wrapped by this instance.
    public private(set) var base: Any

    /// Creates a type-erased colorable value that wraps the given instance.
    ///
    /// - Parameter base: A colorable value to wrap.
    public init<H>(_ base: H) where H : Colorable {
        self.base = base
    }

}

// MARK: AnyRGBColorable
public struct AnyRGBColorable {
    
    /// The value wrapped by this instance.
    public private(set) var base: Any

    /// Creates a type-erased rgb colorable value that wraps the given instance.
    ///
    /// - Parameter base: A rgb colorable value to wrap.
    public init<H>(_ base: H) where H : RGBColorable {
        self.base = base
    }

}

// MARK: Element
public protocol ColorElement {
    typealias Element = Double
    typealias Range = MathRange<Element>
    typealias Vector = MathVector<Element>
    typealias Matrix = MathMatrix<Element>
}

// MARK: Base Color Protocol
public protocol Colorable: Hashable {
    
    var colorSpace: ColorSpaceType { get }
    var elementCount: Int { get }
    
    associatedtype IlluminantType: IlluminantProtocol
    var illuminant: IlluminantType { get set }
    
    init()
    
    var isUpscale: Bool { get set }
    func uppable() -> Self
    func downable() -> Self
    
}

extension Colorable where Self: SomeElementInit {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorSpace)
        hasher.combine(elements)
        hasher.combine(illuminant)
    }
    
}

// MARK: Normal Illuminant Color Protocol
public protocol NormalColorableProtocol: Colorable {
    var illuminant: Illuminant { get set }
}

// MARK: Spectral Illuminant Color Protocol
public protocol SpectralColorableProtocol: Colorable {
    var illuminant: SpectralIlluminant { get set }
}

// MARK: RGB Color Protocol
public protocol RGBColorable: NormalColorableProtocol, SomeElementInit, CustomStringConvertible {
    
    var red: Element { get set }
    var green: Element { get set }
    var blue: Element { get set }
    
    typealias IntTuple = (red: Int, green: Int, blue: Int, illuminant: Illuminant)
    typealias FloatTuple = (red: Element, green: Element, blue: Element, illuminant: Illuminant)
    
    typealias IntUnLumaTuple = (red: Int, green: Int, blue: Int)
    typealias FloatUnLumaTuple = (red: Element, green: Element, blue: Element)
    
    var primaries: Matrix { get }
    
    var gamma: Double { get }
    
    var xyzToRgbMatrices: Matrix { get }
    var rgbToXyzMatrices: Matrix { get }
    
    init(red: Int, green: Int, blue: Int, illuminant: Illuminant)
    init(red: Element, green: Element, blue: Element, illuminant: Illuminant, isUpscale: Bool)
    
    init(gray: Int, illuminant: Illuminant)
    init(gray: Element, illuminant: Illuminant, isUpscale: Bool)
    
    init(rgb: IntTuple)
    init(rgb: FloatTuple)
    
    init(red: Int, green: Int, blue: Int)
    init(red: Element, green: Element, blue: Element, isUpscale: Bool)
    
    init(gray: Int)
    init(gray: Element, isUpscale: Bool)
    
    init(rgb: IntUnLumaTuple)
    init(rgb: FloatUnLumaTuple)
    
    func eotfEncoding() -> TransferFunction.Elements
    func eotfDecoding() -> TransferFunction.Elements
    
}

extension RGBColorable {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.red   /= 255
            result.green /= 255
            result.blue  /= 255
        }
        
        result.isUpscale = false
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.red   *= 255
            result.green *= 255
            result.blue  *= 255
        }
        
        result.isUpscale = true
        
        return result
    }
    
}

extension RGBColorable {
    
    public func matrices(isToRgb: Bool = true) -> Matrix {
        isToRgb ? xyzToRgbMatrices : rgbToXyzMatrices
    }
    
}

extension RGBColorable {
    
    // MARK: - Equatable -
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.colorSpace == rhs.colorSpace &&
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue &&
        lhs.isUpscale == rhs.isUpscale &&
        lhs.illuminant == rhs.illuminant &&
        lhs.primaries == rhs.primaries &&
        lhs.gamma == rhs.gamma &&
        lhs.xyzToRgbMatrices == rhs.xyzToRgbMatrices &&
        lhs.rgbToXyzMatrices == rhs.rgbToXyzMatrices
    }
    
    // MARK: - Hashable -
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorSpace)
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
        hasher.combine(isUpscale)
        hasher.combine(illuminant)
        hasher.combine(primaries)
        hasher.combine(gamma)
        hasher.combine(xyzToRgbMatrices)
        hasher.combine(rgbToXyzMatrices)
    }
    
}

extension RGBColorable {
    
    public var description: String {
        "\(Self.self) { red: \(red), green: \(green), blue: \(blue), illuminant: \(illuminant) }"
    }
    
}

extension RGBColorable {
    
    public static var redUpperRange: ColorElement.Range {
        .init(0, 255)
    }
    
    public static var greenUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    public static var blueUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    public static var alphaUpperRange: ColorElement.Range {
        redUpperRange
    }
    
    
    public static var redDownerRange: ColorElement.Range {
        .init(0, 1)
    }
    
    public static var greenDownerRange: ColorElement.Range {
        redDownerRange
    }
    
    public static var blueDownerRange: ColorElement.Range {
        redDownerRange
    }
    
    public static var alphaDownerRange: ColorElement.Range {
        redDownerRange
    }
    
}

extension RGBColorable {
    
    /// - Tag: ColorProtocol
    public var elementCount: Int { 3 }
    
    /// - Tag: RGBProtocol
    public init(red: Int, green: Int, blue: Int, illuminant: Illuminant) {
        self.init()
        self.red   = .init(min(max(red  , 0), 255))
        self.green = .init(min(max(green, 0), 255))
        self.blue  = .init(min(max(blue , 0), 255))
        self.isUpscale = true
        self.illuminant = illuminant
    }
    
    public init(red: Element, green: Element, blue: Element, illuminant: Illuminant, isUpscale: Bool) {
        guard !isUpscale else {
            self.init(
                red: .init(red), green: .init(green), blue: .init(blue),
                illuminant: illuminant
            )
            return
        }
        self.init()
        self.red   = min(max(red  , 0), 1)
        self.green = min(max(green, 0), 1)
        self.blue  = min(max(blue , 0), 1)
        self.isUpscale = false
        self.illuminant = illuminant
    }
    
    public init(gray: Int, illuminant: Illuminant) {
        self.init(red: gray, green: gray, blue: gray, illuminant: illuminant)
    }
    
    public init(gray: Element, illuminant: Illuminant, isUpscale: Bool) {
        self.init(
            red: gray, green: gray, blue: gray,
            illuminant: illuminant,
            isUpscale: isUpscale
        )
    }
    
    public init(rgb: IntTuple) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: rgb.illuminant
        )
    }
    
    public init(rgb: FloatTuple) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: rgb.illuminant,
            isUpscale: false
        )
    }
    
    public init(red: Int, green: Int, blue: Int) {
        self.init(
            red: red,
            green: green,
            blue: blue,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    public init(red: Element, green: Element, blue: Element, isUpscale: Bool) {
        self.init(
            red: red, green: green, blue: blue,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default,
            isUpscale: isUpscale
        )
    }
    
    public init(gray: Int) {
        self.init(
            gray: gray,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    public init(gray: Element, isUpscale: Bool) {
        self.init(
            gray: gray,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default,
            isUpscale: isUpscale
        )
    }
    
    public init(rgb: IntUnLumaTuple) {
        self.init(
            red: rgb.red,
            green: rgb.green,
            blue: rgb.blue,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    public init(rgb: FloatUnLumaTuple) {
        self.init(
            red: rgb.red,
            green: rgb.green,
            blue: rgb.blue,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default,
            isUpscale: false
        )
    }
    
}

extension RGBColorable {
    
    public init<RGB: RGBColorable>(rgb: RGB, illuminant: Illuminant) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: illuminant,
            isUpscale: rgb.isUpscale
        )
    }
    
    public init<RGB: RGBColorable>(rgb: RGB) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            isUpscale: rgb.isUpscale
        )
    }
    
}

/// - Tag: SomeElementInit
extension RGBColorable {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
    }
    
    public init(array: [Element], isUpscale: Bool, illuminant: Illuminant) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public init(iter elements: Element..., isUpscale: Bool, illuminant: Illuminant) {
        self.init(array: elements, isUpscale: isUpscale, illuminant: illuminant)
    }
    
    public var elements: [Element] {
        [red, green, blue]
    }
    
}

/// - Tag: Linear ( OETF )
extension RGBColorable {
    
    public mutating func eotfEncoded() {
        self = .init(array: self.eotfEncoding())
    }
    
    public mutating func eotfDecoded() {
        self = .init(array: self.eotfDecoding())
    }
    
}

///
/// Defines the behaviour for ``a`` negative numbers and / or the
/// definition return value:
///
/// -   *Indeterminate*: The behaviour will be indeterminate and
///     definition return value might contain *nans*.
/// -   *Mirror*: The definition return value will be mirrored around
///     abscissa and ordinate axis, i.e. Blackmagic Design: Davinci Resolve
///     behaviour.
/// -   *Preserve*: The definition will preserve any negative number in
///     ``a``, i.e. The Foundry Nuke behaviour.
/// -   *Clamp*: The definition will clamp any negative number in ``a`` to
///     0.
///
public enum GammaNegativeNumberHandling: Int {
    case indeterminate, mirror, preserve, clamp
}

// MARK: Element Init
public protocol SomeElementInit: ColorElement {
    var elements: [Element] { get }
    
    init(array: [Element])
    init(iter elements: Element...)
    
}

extension SomeElementInit {
    
    /**
     count = elementCount
     case 1: 没有元素，生成黑色(全为 0)
     case 2: 只有一个元素，自动使用第一个元素复制成 count 个元素
     case 3: 仅有两个元素，最后一个元素补零
     case 4: count 个或 count 个以上元素，截取前 count 个元素
     */
    internal static func initalize(with array: [Element], elementCount count: Int) -> [Element] {
        guard count != 0 else { return [] }
        
        var values = [Element]()
        if array.count == 0 { values = .init(repeating: 0, count: count) }
        if array.count == 1 { values = .init(repeating: array[0], count: count) }
        if array.count == count { values = Array(array[0 ... count - 1]) }
        if array.count > 1 && array.count == count - 1 {
            values = array
            for _ in 0 ..< (count - array.count) { values.append(0) }
        }
        return values
    }
    
}

// MARK: - RGBCommonColorable -
public protocol RGBCommonColorable: RGBColorable {
    
    var rgbColorSpace: ColorSpaceType.RGB { get set }
    
    var primaries: Matrix { get set }
    
    var gamma: Double { get set }
    
    var xyzToRgbMatrices: Matrix { get set }
    var rgbToXyzMatrices: Matrix { get set }
    
    typealias CodingClosure = TransferFunction.CodingClosure
    
    var eotfEncodingClosure: CodingClosure { get set }
    var eotfDecodingClosure: CodingClosure { get set }
    
}

extension RGBCommonColorable {
 
    public static var convertIdentity: Matrix {
        .init(
            [
                1, 0, 0,
                0, 1, 0,
                0, 0, 1
            ],
            3, 3
        )
    }
    
}

extension RGBCommonColorable {
    
    public init<RGB: RGBColorable>(mapping rgb: RGB) {
        self.init(rgb: rgb, illuminant: rgb.illuminant)
        self.rgbColorSpace = .init(color: rgb.colorSpace)
        self.primaries = rgb.primaries
        self.gamma = rgb.gamma
        self.xyzToRgbMatrices = rgb.xyzToRgbMatrices
        self.rgbToXyzMatrices = rgb.rgbToXyzMatrices
        let coder = TransferFunction.funcs[.init(rawValue: rgb.colorSpace.rawValue)!]!
        self.eotfEncodingClosure = coder.encoding
        self.eotfDecodingClosure = coder.decoding
    }
    
    public init(type: ColorSpaceType.RGB, fromRgb rgb: [Element], isUpscale: Bool, illuminant: Illuminant) {
        
        func _rgb<T :RGBColorable>(_ t: T.Type) -> Self {
            let v = T.init(array: rgb, isUpscale: isUpscale, illuminant: illuminant)
            return .init(rgb: v)
        }
        
        switch type {
        case .unknown:           self = _rgb(sRGB.self)
        case .sRGB:              self = _rgb(sRGB.self)
        case .AppleRGB:          self = _rgb(AppleRGB.self)
        case .AdobeRGB:          self = _rgb(AdobeRGB.self)
        case .BT2020RGB:         self = _rgb(BT2020RGB.self)
        case .BT709RGB:          self = _rgb(BT709RGB.self)
        case .DCIP3RGB:          self = _rgb(DCIP3RGB.self)
        case .DCIP3PRGB:         self = _rgb(DCIP3PRGB.self)
        case .DisplayP3RGB:      self = _rgb(DisplayP3RGB.self)
        case .CIERGB:            self = _rgb(CIERGB.self)
        case .AdobeWideGamutRGB: self = _rgb(AdobeWideGamutRGB.self)
        }
        
    }
    
    public init(type: ColorSpaceType.RGB, fromRgb rgb: [Element], isUpscale: Bool) {
        self.init(
            type: type,
            fromRgb: rgb,
            isUpscale: isUpscale,
            illuminant: Illuminant.rgbIlluminants[type] ?? .default
        )
    }
    
    public init(fromRgb rgb: IntUnLumaTuple, type: ColorSpaceType.RGB) {
        self.init(
            type: type,
            fromRgb: [.init(rgb.red), .init(rgb.green), .init(rgb.blue)],
            isUpscale: true
        )
    }
    
    public init(fromRgb rgb: IntTuple, type: ColorSpaceType.RGB) {
        self.init(
            type: type,
            fromRgb: [.init(rgb.red), .init(rgb.green), .init(rgb.blue)],
            isUpscale: true,
            illuminant: rgb.illuminant
        )
    }
    
    public init(fromRgb rgb: FloatUnLumaTuple, type: ColorSpaceType.RGB) {
        self.init(
            type: type,
            fromRgb: [rgb.red, rgb.green, rgb.blue],
            isUpscale: false
        )
    }
    
    public init(fromRgb rgb: FloatTuple, type: ColorSpaceType.RGB) {
        self.init(
            type: type,
            fromRgb: [rgb.red, rgb.green, rgb.blue],
            isUpscale: false,
            illuminant: rgb.illuminant
        )
    }
    
}

extension RGBCommonColorable {
    
    public func eotfEncoding() -> TransferFunction.Elements {
        eotfEncodingClosure(elements)
    }
    
    public func eotfDecoding() -> TransferFunction.Elements {
        eotfDecodingClosure(elements)
    }
    
}

extension RGBCommonColorable {
    
    /// - Tag: Equatable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.colorSpace == rhs.colorSpace &&
        lhs.rgbColorSpace == rhs.rgbColorSpace &&
        lhs.red == rhs.red &&
        lhs.green == rhs.green &&
        lhs.blue == rhs.blue &&
        lhs.isUpscale == rhs.isUpscale &&
        lhs.illuminant == rhs.illuminant &&
        lhs.primaries == rhs.primaries &&
        lhs.gamma == rhs.gamma &&
        lhs.xyzToRgbMatrices == rhs.xyzToRgbMatrices &&
        lhs.rgbToXyzMatrices == rhs.rgbToXyzMatrices
    }
    
    /// - Tag: Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorSpace)
        hasher.combine(rgbColorSpace)
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
        hasher.combine(isUpscale)
        hasher.combine(illuminant)
        hasher.combine(primaries)
        hasher.combine(gamma)
        hasher.combine(xyzToRgbMatrices)
        hasher.combine(rgbToXyzMatrices)
    }
    
}
