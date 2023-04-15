//
//  ColorScalable.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol ColorScalable: ColorElement {
    
    var isUpscale: Bool { get set }
    func uppable() -> Self
    func downable() -> Self
    
}
