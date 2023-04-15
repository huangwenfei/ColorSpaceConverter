//
//  RGBColorable.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol RGBColorable: RGBScalable, NormalColorableProtocol, RGBColorElement, RGBSomeElementInit, CustomStringConvertible {
    
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
    
    init<RGB: RGBColorable>(rgb: RGB, illuminant: Illuminant)
    init<RGB: RGBColorable>(rgb: RGB)
    
    func eotfEncoding() -> TransferFunction.Elements
    func eotfDecoding() -> TransferFunction.Elements
    
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
        "\(Self.self) { red: \(red), green: \(green), blue: \(blue), illuminant: \(illuminant), isUpscale: \(isUpscale) }"
    }
    
}

extension RGBColorable {
    
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

/// - Tag: Linear ( OETF )
extension RGBColorable {
    
    public mutating func eotfEncoded() {
        self = .init(array: self.eotfEncoding())
    }
    
    public mutating func eotfDecoded() {
        self = .init(array: self.eotfDecoding())
    }
    
}

extension RGBColorable {
    
    public init<RGB: RGBCommonColorable>(rgb: RGB, illuminant: Illuminant) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: illuminant,
            isUpscale: rgb.isUpscale
        )
    }
    
    public init<RGB: RGBCommonColorable>(rgb: RGB) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            isUpscale: rgb.isUpscale
        )
    }
    
}
