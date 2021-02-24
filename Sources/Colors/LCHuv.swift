//
//  LCHuv.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public typealias Lch = LCHuv

public struct LCHuv: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .LCHuv }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 100]
    public var l: Element = 0
    /// [0, 100]
    public var u: Element = 0
    /// [0, 360]
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

extension LCHuv {
    
    public static var lUpperRange: ColorElement.Range {
        (0, 100)
    }
    
    public static var uUpperRange: ColorElement.Range {
        lUpperRange
    }
    
    public static var vUpperRange: ColorElement.Range {
        (0, 360)
    }
    
    
    public static var lDownerRange: ColorElement.Range {
        (0, 1)
    }
    
    public static var uDownerRange: ColorElement.Range {
        lDownerRange
    }
    
    public static var vDownerRange: ColorElement.Range {
        lDownerRange
    }
    
}

extension LCHuv {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.l /= 100
            result.u /= 100
            result.v /= 360
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.l *= 100
            result.u *= 100
            result.v *= 360
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension LCHuv: SomeElementInit {

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
