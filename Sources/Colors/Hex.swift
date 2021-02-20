//
//  Hex.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/2/14.
//

import Foundation

public struct Hex: NormalColorableProtocol, ColorElement, CustomStringConvertible {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .Hex }
    public var elementCount: Int { 4 }
    
    public var rgbColorSpace: ColorSpaceType.RGB = .sRGB
    
    // MARK: Color Elements
    /// [0, 255] - [0, 1]
    public var red: Element = 0
    /// [0, 255] - [0, 1]
    public var green: Element = 0
    /// [0, 255] - [0, 1]
    public var blue: Element = 0
    /// [0, 255] - [0, 1]
    public var alpha: Element = 255
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: XYZ Convert
    public static var gamma: Double = sRGB.gamma
    public static var xyzToRgbMatrices: Matrix = sRGB.xyzToRgbMatrices
    public static var rgbToXyzMatrices: Matrix = sRGB.rgbToXyzMatrices
    
    // MARK: Normal Init
    public init() {  }
    
    public init(red: Int, green: Int, blue: Int, alpha: Int = 255, illuminant: Illuminant = .default) {
        self.red = .init(red)
        self.green = .init(green)
        self.blue = .init(blue)
        self.isUpscale = true
        self.illuminant = illuminant
    }
    
    public init(red: Element, green: Element, blue: Element, alpha: Element = 1.0, illuminant: Illuminant = .default) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.isUpscale = false
        self.illuminant = illuminant
    }
    
    public init(gray: Int, alpha: Int, illuminant: Illuminant = .default) {
        self.init(
            red: gray, green: gray, blue: gray, alpha: alpha,
            illuminant: illuminant
        )
    }
    
    public init(gray: Element, alpha: Element, illuminant: Illuminant = .default) {
        self.init(
            red: gray, green: gray, blue: gray, alpha: alpha,
            illuminant: illuminant
        )
    }
    
    /// 0xRGBX Or 0XRGBX Or #RGBX
    public init(byString str: String) {
        self.init()
        
        let hexString = str.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner   = Scanner(string: hexString)
        
        var count = str.count
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
            count -= 1
        } else if hexString.hasPrefix("0x") || hexString.hasPrefix("0X") {
            scanner.scanLocation = 2
            count -= 2
        }
    
        var hexValue: CUnsignedLongLong = 0
        guard scanner.scanHexInt64(&hexValue) else { return }
        
        switch count {
        case 3: self.init(byUInt16: .init(hexValue), haveAlpha: false)
        case 4: self.init(byUInt16: .init(hexValue), haveAlpha: true)
        case 6: self.init(byUInt32: .init(hexValue), haveAlpha: false)
        case 8: self.init(byUInt32: .init(hexValue), haveAlpha: true)
        default:
            // Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8
            break
        }
        
    }
    
    /// 16 Bits 0xRGBX
    public init(byUInt16 uint16: UInt16, haveAlpha: Bool = false) {
        let mask = UInt16(0xF)
        
        let fix: Element = (255.0 / 15.0)
        
        red   = .init(uint16 >> (haveAlpha ? 12 : 8) & mask) * fix
        green = .init(uint16 >> (haveAlpha ? 8 : 4) & mask)  * fix
        blue  = .init(uint16 >> (haveAlpha ? 4 : 0) & mask)  * fix
        alpha = .init(haveAlpha ? (uint16 & mask) : 15)      * fix
        isUpscale = true
        illuminant = .default
        
    }
    
    /// 32 Bits 0xRGBX
    public init(byUInt32 uint32: UInt32, haveAlpha: Bool = false) {
        let mask = UInt32(0xFF)
        
        red   = .init(uint32 >> (haveAlpha ? 24 : 16) & mask)
        green = .init(uint32 >> (haveAlpha ? 16 : 8) & mask)
        blue  = .init(uint32 >> (haveAlpha ? 8 : 0) & mask)
        alpha = .init(haveAlpha ? (uint32 & mask) : 255)
        isUpscale = true
        illuminant = .default
        
    }
    
}

extension Hex {
    
    public init<T: RGBColorable>(rgb: T) {
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self.alpha = rgb.isUpscale ? 255 : 1.0
        self.isUpscale = rgb.isUpscale
        self.illuminant = rgb.illuminant
        self.rgbColorSpace = .init(color: T.self)
        Self.gamma = T.gamma
        Self.xyzToRgbMatrices = T.xyzToRgbMatrices
        Self.rgbToXyzMatrices = T.rgbToXyzMatrices
    }
    
}

extension Hex {
    
    public var description: String {
        "\(hex(havePrefix: true, haveAlpha: true))"
    }
    
    public func hex(havePrefix: Bool = true, haveAlpha: Bool = false) -> String {
        var result = ""
        
        let rgba = uppable()
        
        if havePrefix { result += "#" }
        
        result += .init(
            format: "%02X%02X%02X",
            Int(rgba.red), Int(rgba.green), Int(rgba.blue)
        )
        
        if haveAlpha { result += .init(format: "%02X", Int(rgba.alpha)) }
        
        return result
    }
    
}

extension Hex {
    
    public static var redUpperRange: (min: Element, max: Element) {
        sRGB.redUpperRange
    }
    
    public static var greenUpperRange: (min: Element, max: Element) {
        redUpperRange
    }
    
    public static var blueUpperRange: (min: Element, max: Element) {
        redUpperRange
    }
    
    public static var alphaUpperRange: (min: Element, max: Element) {
        redUpperRange
    }
    
    
    public static var redDownerRange: (min: Element, max: Element) {
        sRGB.redDownerRange
    }
    
    public static var greenDownerRange: (min: Element, max: Element) {
        redUpperRange
    }
    
    public static var blueDownerRange: (min: Element, max: Element) {
        redUpperRange
    }
    
    public static var alphaDownerRange: (min: Element, max: Element) {
        redUpperRange
    }
    
}

extension Hex {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.red   /= 255
            result.green /= 255
            result.blue  /= 255
            result.alpha /= 255
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.red   *= 255
            result.green *= 255
            result.blue  *= 255
            result.alpha *= 255
        }
        
        return result
    }
    
}

extension Hex {
    
    
    
}

/// - Tag: SomeElementInit
extension Hex: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2] ; alpha = values[3]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [red, green, blue, alpha]
    }
    
}
