//
//  XYZ.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

public struct XYZ: NormalColorableProtocol, ColorElement {
    
    // MARK: ColorProtocol
    public var colorSpace: ColorSpaceType { .XYZ }
    public var elementCount: Int { 3 }
    
    // MARK: Color Elements
    /// [0, 1]
    public var x: Element = 0
    public var y: Element = 0
    public var z: Element = 0
    
    public var isUpscale: Bool = false
    
    public var illuminant: Illuminant = .default
    
    // MARK: Normal Init
    public init() {  }
    
    public init(x: Element, y: Element, z: Element, isUpscale: Bool = false, illuminant: Illuminant = .default) {
        self.x = x
        self.y = y
        self.z = z
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
}

extension XYZ {
    
    public func downable() -> Self {
        
        var result = self
        
        if isUpscale {
            result.x /= 95.047
            result.y /= 100
            result.z /= 108.883
        }
        
        return result
    }
    
    public func uppable() -> Self {
        
        var result = self
        
        if !isUpscale {
            result.x *= 95.047
            result.y *= 100
            result.z *= 108.883
        }
        
        return result
    }
    
}

/// - Tag: SomeElementInit
extension XYZ: SomeElementInit {

    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        x = values[0] ; y = values[1] ; z = values[2]
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public var elements: [Element] {
        [x, y, z]
    }
    
}

extension XYZ {
    
    public mutating func applyAdaptation(illuminant: Illuminant, adaptation: ChromaticAdaptation.Adaptation = .bradford) {
        
        guard self.illuminant != illuminant else { return }
        
        /// - Tag: This applies an adaptation matrix to change the XYZ color's illuminant. You'll most likely only need this during RGB conversions.
        
        /// - Tag: If the XYZ values were taken with a different reference white than the native reference white of the target RGB space, a transformation matrix must be applied.
        
        /// - Tag: Sets the adjusted XYZ values, and the new illuminant.
        ChromaticAdaptation.adaptation(
            forXyz: &self, adaptation: adaptation, illuminant: illuminant
        )

    }
    
}
