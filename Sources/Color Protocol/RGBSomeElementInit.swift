//
//  RGBSomeElementInit.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol RGBSomeElementInit: SomeElementInit {
    
    init(array: [Element], isUpscale: Bool, illuminant: Illuminant)
    init(iter elements: Element..., isUpscale: Bool, illuminant: Illuminant)
    
}

extension RGBSomeElementInit where Self: Colorable & RGBScalable, IlluminantType == Illuminant {
    
    public var elementCount: Int { 3 }
    
    public init(array: [Element]) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
    }
    
    public init(array: [Element], isUpscale: Bool, illuminant: Illuminant) {
        self.init()
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
        self.isUpscale = isUpscale
        self.illuminant = illuminant
    }
    
    public init(iter elements: Element...) {
        self.init(array: elements)
    }
    
    public init(iter elements: Element..., isUpscale: Bool, illuminant: Illuminant) {
        self.init(array: elements, isUpscale: isUpscale, illuminant: illuminant)
    }
    
    public var elements: [Element] {
        [red, green, blue]
    }
    
}
