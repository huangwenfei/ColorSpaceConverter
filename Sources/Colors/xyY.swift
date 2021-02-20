//
//  xyY.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public typealias Yxy = xyY

public struct xyY: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .xyY }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var x: Element = 0
    public var y: Element = 0
    public var Y: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(x: Element, y: Element, Y: Element, illuminant: Illuminant = .default) {
        self.x = x
        self.y = y
        self.Y = Y
        self.illuminant = illuminant
    }
    
}

extension xyY {
    
    public static var xUpperRange: (min: Element, max: Element) {
        (0, 73.417721519)
    }
    
    public static var yUpperRange: (min: Element, max: Element) {
        (0, 83.291139241)
    }
    
    public static var zUpperRange: (min: Element, max: Element) {
        (0, 100)
    }
    
    
    public static var xDownerRange: (min: Element, max: Element) {
        (0, 1)
    }
    
    public static var yDownerRange: (min: Element, max: Element) {
        xDownerRange
    }
    
    public static var zDownerRange: (min: Element, max: Element) {
        xDownerRange
    }
    
}

extension xyY {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.x /= 73.417721519
            result.y /= 83.291139241
            result.Y /= 100
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.x *= 73.417721519
            result.y *= 83.291139241
            result.Y *= 100
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension xyY: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        x = values[0] ; y = values[1] ; Y = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [x, y, Y]
    }
    
}
