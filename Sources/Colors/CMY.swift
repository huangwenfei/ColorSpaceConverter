//
//  CMY.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct CMY: NormalColorableProtocol {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .CMY }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var c: Element = 0
    public var m: Element = 0
    public var y: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(c: Element, m: Element, y: Element, isUpscale: Bool = false, illuminant: Illuminant = .default) {
        self.c = c
        self.m = m
        self.y = y
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension CMY {
    
    public static var cUpperRange: ColorElement.Range {
        (0, 100)
    }
    
    public static var mUpperRange: ColorElement.Range {
        cUpperRange
    }
    
    public static var yUpperRange: ColorElement.Range {
        cUpperRange
    }
    
    
    public static var cDownerRange: ColorElement.Range {
        (0, 1)
    }
    
    public static var mDownerRange: ColorElement.Range {
        cDownerRange
    }
    
    public static var yDownerRange: ColorElement.Range {
        cDownerRange
    }
    
}

extension CMY {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.c /= 100
            result.m /= 100
            result.y /= 100
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.c *= 100
            result.m *= 100
            result.y *= 100
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension CMY: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        c = values[0] ; m = values[1] ; y = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [c, m, y]
    }
    
}
