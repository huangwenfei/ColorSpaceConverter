//
//  ColorPathSelector.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2020/12/28.
//  Copyright © 2020 黄文飞. All rights reserved.
//

import Foundation
import Accelerate

public struct ColorPathSelector {
    
    // MARK: - Types -
    public typealias Element = ColorElement.Element
    public typealias SelectorDict = [PathId: PathConverter]
    
    // MARK: - Selector
    public typealias Selector = (_ from: AnyColorable, _ infos: [AnyHashable: Any]?) -> AnyColorable

    public static let selectors: SelectorDict =
        SpectralSelector.selectors ++
        LabSelector.selectors ++
        LuvSelector.selectors ++
        LCHabSelector.selectors ++
        LCHuvSelector.selectors ++
        xyYSelector.selectors ++
        XYZSelector.selectors ++
        RGBSelector.selectors ++
        HexSeletor.selectors ++
        RGBColorSeletor.selectors ++
        HSVSelector.selectors ++
        HSLSelector.selectors ++
        CMYSelector.selectors ++
        CMYKSelector.selectors ++
        IPTSelector.selectors

    public static func selector(byPathId pathId: PathId) -> PathConverter? {
        selectors[pathId]
    }
    
}

infix operator ++ : AdditionPrecedence
fileprivate func ++ (left: ColorPathSelector.SelectorDict, right: ColorPathSelector.SelectorDict) -> ColorPathSelector.SelectorDict {
    
    var result: Dictionary<PathId, PathConverter> = [:]
    
    for (key, value) in left  { result[key] = value }
    for (key, value) in right { result[key] = value }
    
    return result
}
