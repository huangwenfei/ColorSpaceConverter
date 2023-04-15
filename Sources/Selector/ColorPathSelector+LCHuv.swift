//
//  ColorPathSelector+LCHuv.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

extension ColorPathSelector {
    public struct LCHuvSelector {
        
        public static let selectors: ColorPathSelector.SelectorDict = [
            toLuv.pathId: toLuv
        ]
        
        public static let toLuv: PathConverter = .init( .LCHuv ==> .Luv ) {
            .init( Self.toLuv(color: ($0.base as! LCHuv), infos: $1) )
        }
        
    }
}

extension ColorPathSelector.LCHuvSelector {
    
    public static func toLuv(color: LCHuv, infos: [AnyHashable: Any]?) -> Luv {
        
        let l = color.l
        let u = cos(Math.radians(color.v)) * color.u
        let v = sin(Math.radians(color.v)) * color.u
        
        return .init(
            l: l, u: u, v: v, illuminant: color.illuminant
        )
    
    }
    
}
