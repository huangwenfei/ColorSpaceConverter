//
//  ColorSomeElementInit.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/16.
//

import Foundation

public protocol ColorSomeElementInit: SomeElementInit {
    
    init(array: [Element])
    init(iter elements: Element...)
    
}
