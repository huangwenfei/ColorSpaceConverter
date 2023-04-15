//
//  ColorPathSelector+CMYK.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct CMYKSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toCMY.pathId: toCMY
        ]
        
        public static let toCMY: PathConverter = .init( .CMYK ==> .CMY ) {
            .init( Self.toCMY(color: ($0.base as! CMYK), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.CMYKSelector {
    
    public static func toCMY(color: CMYK, infos: [AnyHashable: Any]?) -> CMY {
        
        /// NOTE: CMYK and CMY values range from 0.0 to 1.0

        let downable = color.downable()
        
        let c = downable.c * (1.0 - downable.k) + downable.k
        let m = downable.m * (1.0 - downable.k) + downable.k
        let y = downable.y * (1.0 - downable.k) + downable.k

        return .init(c: c, m: m, y: y, illuminant: color.illuminant)
        
    }
    
}
