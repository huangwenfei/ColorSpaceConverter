//
//  IPT.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct IPT: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .IPT }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var i: Element = 0
    /// [-1, 1]
    public var p: Element = 0
    /// [-1, 1]
    public var t: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    public static var xyzToLmsMatrices: Matrix {
        (
            [
                 0.4002, 0.7075, -0.0807,
                -0.2280, 1.1500,  0.0612,
                 0.0000, 0.0000,  0.9184,
            ],
            3, 3
        )
    }
    
    public static var lmstoIptMatrices: Matrix {
        (
            [
                0.4000,  0.4000,  0.2000,
                4.4550, -4.8510,  0.3960,
                0.8056,  0.3572, -1.1628,
            ],
            3, 3
        )
    }
    
    // MARK: Normal Init
    public init() {  }
    
    public init(i: Element, p: Element, t: Element, isUpscale: Bool = false, illuminant: Illuminant = .default) {
        self.i = i
        self.p = p
        self.t = t
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension IPT {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.i /= 100
            result.p /= (result.p > 0 ? 100 : -100)
            result.t /= (result.t > 0 ? 100 : -100)
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.i *= 100
            result.p *= (result.p > 0 ? 100 : -100)
            result.t *= (result.t > 0 ? 100 : -100)
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension IPT: SomeElementInit {

    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        i = values[0] ; p = values[1] ; t = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [i, p, t]
    }
    
}
