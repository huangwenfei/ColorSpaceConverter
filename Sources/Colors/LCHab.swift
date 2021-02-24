//
//  LCHab.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public typealias LCH = LCHab

public struct LCHab: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .LCHab }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 100]
    public var l: Element = 0
    /// [0, 100]
    public var a: Element = 0
    /// [0, 360]
    public var b: Element = 0
    
    public var isUpscale: Bool = true
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(l: Element, a: Element, b: Element, isUpscale: Bool = true, illuminant: Illuminant = .default) {
        self.l = l
        self.a = a
        self.b = b
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension LCHab {
    
    public static var lUpperRange: ColorElement.Range {
        (0, 100)
    }
    
    public static var aUpperRange: ColorElement.Range {
        lUpperRange
    }
    
    public static var bUpperRange: ColorElement.Range {
        (0, 360)
    }
    
    
    public static var lDownerRange: ColorElement.Range {
        (0, 1)
    }
    
    public static var aDownerRange: ColorElement.Range {
        lDownerRange
    }
    
    public static var bDownerRange: ColorElement.Range {
        lDownerRange
    }
    
}

extension LCHab {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.l /= 100
            result.a /= 100
            result.b /= 360
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.l *= 100
            result.a *= 100
            result.b *= 360
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension LCHab: SomeElementInit {

    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        l = values[0] ; a = values[1] ; b = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [l, a, b]
    }
    
}
