//
//  ColorProtocol.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/11/13.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation

// MARK: Base Color Protocol
public protocol Colorable: ColorScalable, Hashable {
    
    var colorSpace: ColorSpaceType { get }
    
    associatedtype IlluminantType: IlluminantProtocol
    var illuminant: IlluminantType { get set }
    
    init()
    
}

extension Colorable where Self: SomeElementInit {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.colorSpace == rhs.colorSpace &&
        lhs.elements == rhs.elements &&
        lhs.isUpscale == rhs.isUpscale &&
        lhs.illuminant == rhs.illuminant
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(colorSpace)
        hasher.combine(elements)
        hasher.combine(isUpscale)
        hasher.combine(illuminant)
    }
    
}












