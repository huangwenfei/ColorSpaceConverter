//
//  HSL.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct HSL: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .HSL }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var h: Element = 0
    /// [0, 1]
    public var s: Element = 0
    /// [0, 1]
    public var l: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(h: Int, s: Int, l: Int, illuminant: Illuminant = .default) {
        self.h = .init(h)
        self.s = .init(s)
        self.l = .init(l)
        self.isUpscale = true
        self.illuminant = illuminant
    }
    
    public init(h: Element, s: Element, l: Element, illuminant: Illuminant = .default) {
        self.h = h
        self.s = s
        self.l = l
        self.isUpscale = false
        self.illuminant = illuminant
    }
    
}

extension HSL {
    
    public static var hUpperRange: (min: Element, max: Element) {
        (0, 360)
    }
    
    public static var sUpperRange: (min: Element, max: Element) {
        (0, 100)
    }
    
    public static var lUpperRange: (min: Element, max: Element) {
        sUpperRange
    }
    
    
    public static var hDownerRange: (min: Element, max: Element) {
        (0, 1)
    }
    
    public static var sDownerRange: (min: Element, max: Element) {
        hDownerRange
    }
    
    public static var lDownerRange: (min: Element, max: Element) {
        hDownerRange
    }
    
}

extension HSL {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.h /= 360
            result.s /= 100
            result.l /= 100
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.h *= 360
            result.s *= 100
            result.l *= 100
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension HSL: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        h = values[0] ; s = values[1] ; l = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [h, s, l]
    }
    
}
