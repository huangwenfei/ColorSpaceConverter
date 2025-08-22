//
//  RGBCommonSomeElementInit.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/16.
//

import Foundation

public protocol RGBCommonSomeElementInit: SomeElementInit {
    
    init(type: ColorSpaceType.RGB, array: [Element])
    init(type: ColorSpaceType.RGB, array: [Element], isUpscale: Bool, illuminant: Illuminant)
    init(type: ColorSpaceType.RGB, iter elements: Element...)
    init(type: ColorSpaceType.RGB, iter elements: Element..., isUpscale: Bool, illuminant: Illuminant)
    
}

extension RGBCommonSomeElementInit where Self: RGBCommonColorable, IlluminantType == Illuminant {
    
    public var elementCount: Int { 3 }
    
    public init(type: ColorSpaceType.RGB, array: [Element]) {
        self.init(type: type, red: 0, green: 0, blue: 0, isUpscale: false)
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
    }
    
    public init(type: ColorSpaceType.RGB, array: [Element], isUpscale: Bool, illuminant: Illuminant) {
        self.init(type: type, red: 0, green: 0, blue: 0, isUpscale: isUpscale, illuminant: illuminant)
        let values = Self.initalize(with: array, elementCount: elementCount)
        red = values[0] ; green = values[1] ; blue = values[2]
    }
    
    public init(type: ColorSpaceType.RGB, iter elements: Element...) {
        self.init(type: type, array: elements)
    }
    
    public init(type: ColorSpaceType.RGB, iter elements: Element..., isUpscale: Bool, illuminant: Illuminant) {
        self.init(type: type, array: elements, isUpscale: isUpscale, illuminant: illuminant)
    }
    
    public var elements: [Element] {
        [red, green, blue]
    }
    
}
