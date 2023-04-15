//
//  RGBColorElement.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol RGBColorElement: ColorElement {
    typealias IntTuple = (red: Int, green: Int, blue: Int, illuminant: Illuminant)
    typealias FloatTuple = (red: Element, green: Element, blue: Element, illuminant: Illuminant)
    
    typealias IntUnLumaTuple = (red: Int, green: Int, blue: Int)
    typealias FloatUnLumaTuple = (red: Element, green: Element, blue: Element)
}
