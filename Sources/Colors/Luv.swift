//
//  Luv.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct Luv: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .Luv }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 100]
    public var l: Element = 0
    /// [-100, 100]
    public var u: Element = 0
    /// [-100, 100]
    public var v: Element = 0
    
    public var isUpscale: Bool = true
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(l: Element, u: Element, v: Element, isUpscale: Bool = true, illuminant: Illuminant = .default) {
        self.l = l
        self.u = u
        self.v = v
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension Luv {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.l /= 100
            result.u /= (result.u > 0 ? 100 : -100)
            result.v /= (result.v > 0 ? 100 : -100)
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.l *= 100
            result.u *= (result.u > 0 ? 100 : -100)
            result.v *= (result.v > 0 ? 100 : -100)
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension Luv: SomeElementInit {
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        l = values[0] ; u = values[1] ; v = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [l, u, v]
    }
    
}
