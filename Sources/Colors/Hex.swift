//
//  Hex.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2021/2/14.
//

import Foundation

public struct Hex: RGBCommonColorable {
    
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
    public var alpha: Element = 1.0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    public var primaries: Matrix = .init()

    public var gamma: Double = TransferFunction.LinearRGB.gamma
    
    public var xyzToRgbMatrices: Matrix = Self.convertIdentity
    public var rgbToXyzMatrices: Matrix = Self.convertIdentity
    
    // MARK: Normal Init
    public init() {  }
    
    // MARK: Gamma Map
    public var eotfEncodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfEncoding($0)
    }
    
    public var eotfDecodingClosure: CodingClosure = {
        TransferFunction.LinearRGB.eotfDecoding($0)
    }
    
    // TODO: malloc: Non-aligned pointer 0x600000740540 being freed (2)
    // Info:
    // 1. https://stackoverflow.com/questions/4055277/non-aligned-pointer-being-freed-on-mac 可能只是不同的malloc实现。可能Mac的malloc对齐到更大的边界，因此它会发现您传递给free的指针可能不正确，因为它具有错误的对齐方式。然而，它表示您正在向free()传递一个不是来自malloc()的指针。这肯定是一个bug的迹象，可能在您的所有平台上都会出现。
    // 2.这个错误提示来自于C语言的malloc函数，在使用malloc函数分配内存后，释放内存时如果指针不是按照内存对齐要求分配的，则会出现该提示。这种情况可能因为代码中存在指针运算错误、未正确使用指针或者类型转换问题等原因导致。如果在Swift代码中遇到类似的问题，建议检查代码中是否存在这些问题，并进行相应的修改。
    public init<T: RGBColorable>(rgb: T.Type) {
        self.rgbColorSpace = .init(color: T.self)
    }
    
    public init(red: Int, green: Int, blue: Int, alpha: Int = 255, illuminant: Illuminant = .default) {
        self.init(red: red, green: green, blue: blue, alpha: alpha, illuminant: illuminant, rgb: sRGB.self)
    }
    
    public init<T: RGBColorable>(red: Int, green: Int, blue: Int, alpha: Int = 255, illuminant: Illuminant = .default, rgb: T.Type) {
        
        self.init(rgb: rgb)
        
        self.red = .init(red)
        self.green = .init(green)
        self.blue = .init(blue)
        self.isUpscale = true
        self.illuminant = illuminant
        
    }
    
    public init(red: Element, green: Element, blue: Element, alpha: Element = 1.0, illuminant: Illuminant = .default) {
        self.init(red: red, green: green, blue: blue, alpha: alpha, illuminant: illuminant, rgb: sRGB.self)
    }
    
    public init<T: RGBColorable>(red: Element, green: Element, blue: Element, alpha: Element = 1.0, illuminant: Illuminant = .default, rgb: T.Type) {
        
        self.init(rgb: rgb)
        
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
    
    public init<T: RGBColorable>(gray: Int, alpha: Int, illuminant: Illuminant = .default, rgb: T.Type) {
        self.init(
            red: gray, green: gray, blue: gray, alpha: alpha,
            illuminant: illuminant,
            rgb: rgb
        )
    }
    
    public init(gray: Element, alpha: Element, illuminant: Illuminant = .default) {
        self.init(
            red: gray, green: gray, blue: gray, alpha: alpha,
            illuminant: illuminant
        )
    }
    
    public init<T: RGBColorable>(gray: Element, alpha: Element, illuminant: Illuminant = .default, rgb: T.Type) {
        self.init(
            red: gray, green: gray, blue: gray, alpha: alpha,
            illuminant: illuminant,
            rgb: rgb
        )
    }
    
    /// 0xRGBX Or 0XRGBX Or #RGBX
    public init(byString str: String) {
        self.init(byString: str, rgb: sRGB.self)
    }
    
    public init<T: RGBColorable>(byString str: String, rgb: T.Type) {
        
        self.init(rgb: rgb)
        
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
        case 3: self.init(byUInt16: .init(hexValue), haveAlpha: false, rgb: rgb)
        case 4: self.init(byUInt16: .init(hexValue), haveAlpha: true, rgb: rgb)
        case 6: self.init(byUInt32: .init(hexValue), haveAlpha: false, rgb: rgb)
        case 8: self.init(byUInt32: .init(hexValue), haveAlpha: true, rgb: rgb)
        default:
            // Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8
            break
        }
        
    }
    
    /// 16 Bits 0xRGBX
    public init(byUInt16 uint16: UInt16, haveAlpha: Bool = false) {
        self.init(byUInt16: uint16, haveAlpha: haveAlpha, rgb: sRGB.self)
    }
    
    public init<T: RGBColorable>(byUInt16 uint16: UInt16, haveAlpha: Bool = false, rgb: T.Type) {
        
        self.init(rgb: rgb)
        
        let mask = UInt16(0xF)
        
        let fix: Element = (255.0 / 15.0)
        
        red   = .init(uint16 >> (haveAlpha ? 12 : 8) & mask) * fix
        green = .init(uint16 >> (haveAlpha ? 8 : 4) & mask)  * fix
        blue  = .init(uint16 >> (haveAlpha ? 4 : 0) & mask)  * fix
        alpha = .init(haveAlpha ? (uint16 & mask) : 15)      * fix
        isUpscale = true
        
    }
    
    /// 32 Bits 0xRGBX
    public init(byUInt32 uint32: UInt32, haveAlpha: Bool = false) {
        self.init(byUInt32: uint32, haveAlpha: haveAlpha, rgb: sRGB.self)
    }
    
    public init<T: RGBColorable>(byUInt32 uint32: UInt32, haveAlpha: Bool = false, rgb: T.Type) {
        
        self.init(rgb: rgb)
        
        let mask = UInt32(0xFF)
        
        red   = .init(uint32 >> (haveAlpha ? 24 : 16) & mask)
        green = .init(uint32 >> (haveAlpha ? 16 : 8) & mask)
        blue  = .init(uint32 >> (haveAlpha ? 8 : 0) & mask)
        alpha = .init(haveAlpha ? (uint32 & mask) : 255)
        isUpscale = true
        
    }
    
}

extension Hex {
    
    public init<T: RGBColorable>(rgb: T) {
        self.init(rgb: T.self)
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        self.alpha = rgb.isUpscale ? 255 : 1.0
        self.isUpscale = rgb.isUpscale
        self.illuminant = rgb.illuminant
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
    
    public static var rgbUInt32Range: ClosedRange<UInt32> {
        0x000000 ... 0xFFFFFF
    }
    
    public static var rgbaUInt32Range: ClosedRange<UInt64> {
        0x00000000 ... 0xFFFFFFFF
    }
    
    public static var rgbRange: String {
        "[#000000, #FFFFFF]"
    }
    
    public static var rgbaRange: String {
        "[#00000000, #FFFFFFFF]"
    }
    
    public static var redUpperRange: ColorElement.Range {
        sRGB.redUpperRange
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
        sRGB.redDownerRange
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

extension Hex {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.red   /= 255
            result.green /= 255
            result.blue  /= 255
            result.alpha /= 255
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
            result.alpha *= 255
        }
        
        result.isUpscale = true
        
        return result
    }
    
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
