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

// MARK: Element
public protocol ColorElement {
    typealias Element = Double
    typealias Vector = (values: [Element], count: Int)
    typealias Matrix = (values: [Element], rows: Int, columns: Int)
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
    
    static var gamma: Double { get }
    
    static var xyzToRgbMatrices: Matrix { get }
    static var rgbToXyzMatrices: Matrix { get }
    
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
    
}

extension RGBColorable {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.red   /= 255
            result.green /= 255
            result.blue  /= 255
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.red   *= 255
            result.green *= 255
            result.blue  *= 255
        }
        
        return result
    }
    
}

extension RGBColorable {
    
    public static func matrices(isToRgb: Bool = true) -> Matrix {
        isToRgb ? xyzToRgbMatrices : rgbToXyzMatrices
    }
    
}

extension RGBColorable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorSpace)
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
        hasher.combine(illuminant)
    }
    
}

extension RGBColorable {
    
    public var description: String {
        "{ red: \(red), green: \(green), blue: \(blue), illuminant: \(illuminant) }"
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
        self.init(red: red, green: green, blue: blue, illuminant: .default)
    }
    
    public init(red: Element, green: Element, blue: Element, isUpscale: Bool) {
        self.init(
            red: red, green: green, blue: blue,
            illuminant: .default,
            isUpscale: isUpscale
        )
    }
    
    public init(gray: Int) {
        self.init(gray: gray, illuminant: .default)
    }
    
    public init(gray: Element, isUpscale: Bool) {
        self.init(gray: gray, illuminant: .default, isUpscale: isUpscale)
    }
    
    public init(rgb: IntUnLumaTuple) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: .default
        )
    }
    
    public init(rgb: FloatUnLumaTuple) {
        self.init(
            red: rgb.red, green: rgb.green, blue: rgb.blue,
            illuminant: .default,
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
    
}

/// - Tag: SomeElementInit
extension RGBColorable {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [red, green, blue]
    }
    
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

