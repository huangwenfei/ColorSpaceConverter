//
//  RGBCommonColorable.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol RGBCommonColorable: RGBScalable, NormalColorableProtocol, RGBColorElement, RGBCommonSomeElementInit, CustomStringConvertible {
    
    var rgbColorSpace: ColorSpaceType.RGB { get set }
    
    var primaries: Matrix { get set }
    
    var gamma: Double { get set }
    
    var xyzToRgbMatrices: Matrix { get set }
    var rgbToXyzMatrices: Matrix { get set }
    
    typealias CodingClosure = TransferFunction.CodingClosure
    
    var eotfEncodingClosure: CodingClosure { get set }
    var eotfDecodingClosure: CodingClosure { get set }
    
    init(type: ColorSpaceType.RGB, red: Int, green: Int, blue: Int, illuminant: Illuminant)
    init(type: ColorSpaceType.RGB, red: Element, green: Element, blue: Element, isUpscale: Bool, illuminant: Illuminant)
    
    init(type: ColorSpaceType.RGB, gray: Int, illuminant: Illuminant)
    init(type: ColorSpaceType.RGB, gray: Element, isUpscale: Bool, illuminant: Illuminant)
    
    init(type: ColorSpaceType.RGB, red: Int, green: Int, blue: Int)
    init(type: ColorSpaceType.RGB, red: Element, green: Element, blue: Element, isUpscale: Bool)
    
    init(type: ColorSpaceType.RGB, gray: Int)
    init(type: ColorSpaceType.RGB, gray: Element, isUpscale: Bool)
    
    init<RGB: RGBColorable>(rgb: RGB)
    init(type: ColorSpaceType.RGB, fromRgb rgb: [Element], isUpscale: Bool, illuminant: Illuminant)
    init(type: ColorSpaceType.RGB, fromRgb rgb: [Element], isUpscale: Bool)
    init(fromRgb rgb: IntUnLumaTuple, type: ColorSpaceType.RGB)
    init(fromRgb rgb: IntTuple, type: ColorSpaceType.RGB)
    init(fromRgb rgb: FloatUnLumaTuple, type: ColorSpaceType.RGB)
    init(fromRgb rgb: FloatTuple, type: ColorSpaceType.RGB)
    
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
    
    public var description: String {
        "\(Self.self) { rgbType: \(rgbColorSpace), red: \(red), green: \(green), blue: \(blue), illuminant: \(illuminant), isUpscale: \(isUpscale) }"
    }
    
}

extension RGBCommonColorable {
    
    public init(type: ColorSpaceType.RGB, red: Int, green: Int, blue: Int, illuminant: Illuminant) {
        let elements: [Element] = [
            Element(min(max(red  , 0), 255)),
            Element(min(max(green, 0), 255)),
            Element(min(max(blue , 0), 255))
        ]
        self.init(type: type, fromRgb: elements, isUpscale: true, illuminant: illuminant)
    }
    
    public init(type: ColorSpaceType.RGB, red: Element, green: Element, blue: Element, isUpscale: Bool, illuminant: Illuminant) {
        
        guard !isUpscale else {
            self.init(
                type: type, red: .init(red), green: .init(green), blue: .init(blue),
                illuminant: illuminant
            )
            return
        }
        
        let elements: [Element] = [
            Element(min(max(red  , 0), 1)),
            Element(min(max(green, 0), 1)),
            Element(min(max(blue , 0), 1))
        ]
        self.init(type: type, fromRgb: elements, isUpscale: isUpscale, illuminant: illuminant)
    }
    
    
    public init(type: ColorSpaceType.RGB, gray: Int, illuminant: Illuminant) {
        self.init(type: type, red: gray, green: gray, blue: gray, illuminant: illuminant)
    }
    
    public init(type: ColorSpaceType.RGB, gray: Element, isUpscale: Bool, illuminant: Illuminant) {
        self.init(
            type: type,
            red: gray, green: gray, blue: gray,
            isUpscale: isUpscale,
            illuminant: illuminant
        )
    }
    
    
    public init(type: ColorSpaceType.RGB, red: Int, green: Int, blue: Int) {
        self.init(
            type: type,
            red: red,
            green: green,
            blue: blue,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    public init(type: ColorSpaceType.RGB, red: Element, green: Element, blue: Element, isUpscale: Bool) {
        self.init(
            type: type,
            red: red, green: green, blue: blue,
            isUpscale: isUpscale,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    
    public init(type: ColorSpaceType.RGB, gray: Int) {
        self.init(
            type: type,
            gray: gray,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
    public init(type: ColorSpaceType.RGB, gray: Element, isUpscale: Bool) {
        self.init(
            type: type,
            gray: gray,
            isUpscale: isUpscale,
            illuminant: Illuminant.rgbIlluminants[.init(color: Self.self)] ?? .default
        )
    }
    
}

extension RGBCommonColorable {
    
    public init<RGB: RGBColorable>(rgb: RGB) {
        self.init()
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self.isUpscale = rgb.isUpscale
        self.illuminant = rgb.illuminant
        self.rgbColorSpace = .init(color: rgb.colorSpace)
        self.primaries = rgb.primaries
        self.gamma = rgb.gamma
        self.xyzToRgbMatrices = rgb.xyzToRgbMatrices
        self.rgbToXyzMatrices = rgb.rgbToXyzMatrices
        let coder = TransferFunction.funcs[.init(rawValue: rgb.colorSpace.rawValue)!]!
        self.eotfEncodingClosure = coder.encoding
        self.eotfDecodingClosure = coder.decoding
    }
    
    public init<RGB: RGBCommonColorable>(rgb: RGB) {
        self.init()
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self.isUpscale = rgb.isUpscale
        self.illuminant = rgb.illuminant
        self.rgbColorSpace = rgb.rgbColorSpace
        self.primaries = rgb.primaries
        self.gamma = rgb.gamma
        self.xyzToRgbMatrices = rgb.xyzToRgbMatrices
        self.rgbToXyzMatrices = rgb.rgbToXyzMatrices
        let coder = TransferFunction.funcs[rgb.rgbColorSpace]!
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
