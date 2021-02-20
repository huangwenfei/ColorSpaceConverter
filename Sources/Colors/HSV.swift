//
//  HSV.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct HSV: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .HSV }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 360]
    public var h: Element = 0
    /// [0, 1]
    public var s: Element = 0
    /// [0, 1]
    public var v: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(h: Int, s: Int, v: Int, illuminant: Illuminant = .default) {
        self.h = .init(h)
        self.s = .init(s)
        self.v = .init(v)
        self.isUpscale = true
        self.illuminant = illuminant
    }
    
    public init(h: Element, s: Element, v: Element, illuminant: Illuminant = .default) {
        self.h = h
        self.s = s
        self.v = v
        self.isUpscale = false
        self.illuminant = illuminant
    }
    
}

extension HSV {
    
    public static var hUpperRange: (min: Element, max: Element) {
        (0, 360)
    }
    
    public static var sUpperRange: (min: Element, max: Element) {
        (0, 100)
    }
    
    public static var vUpperRange: (min: Element, max: Element) {
        sUpperRange
    }
    
    
    public static var hDownerRange: (min: Element, max: Element) {
        (0, 360)
    }
    
    public static var sDownerRange: (min: Element, max: Element) {
        (0, 1)
    }
    
    public static var vDownerRange: (min: Element, max: Element) {
        sDownerRange
    }
    
}

extension HSV {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.s /= 100
            result.v /= 100
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.s *= 100
            result.v *= 100
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension HSV: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        h = values[0] ; s = values[1] ; v = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [h, s, v]
    }
    
}
