//
//  CMYK.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct CMYK: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .CMYK }
    public var elementCount: Int { 4 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var c: Element = 0
    public var m: Element = 0
    public var y: Element = 0
    public var k: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(c: Element, m: Element, y: Element, k: Element, isUpscale: Bool = false, illuminant: Illuminant = .default) {
        self.c = c
        self.m = m
        self.y = y
        self.k = k
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension CMYK {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.c /= 100
            result.m /= 100
            result.y /= 100
            result.k /= 100
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.c *= 100
            result.m *= 100
            result.y *= 100
            result.k *= 100
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension CMYK: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        c = values[0] ; m = values[1] ; y = values[2] ; k = values[3]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [c, m, y, k]
    }
    
}
