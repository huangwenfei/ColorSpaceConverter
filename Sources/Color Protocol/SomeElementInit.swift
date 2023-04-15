//
//  SomeElementInit.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol SomeElementInit: ColorElement {
    
    var elements: [Element] { get }
    var elementCount: Int { get }
    
    init(array: [Element])
    init(iter elements: Element...)
    
}

extension SomeElementInit {
    
    /**
     count = elementCount
     case 1: 没有元素，生成黑色(全为 0)
     case 2: 只有一个元素，自动使用第一个元素复制成 count 个元素
     case 3: 仅有两个元素，最后一个元素补零
     case 4: count 个或 count 个以上元素，截取前 count 个元素
     */
    internal static func initalize(with array: [Element], elementCount count: Int) -> [Element] {
        guard count != 0 else { return [] }
        
        var values = [Element]()
        if array.count == 0 { values = .init(repeating: 0, count: count) }
        if array.count == 1 { values = .init(repeating: array[0], count: count) }
        if array.count == count { values = Array(array[0 ... count - 1]) }
        if array.count > 1 && array.count == count - 1 {
            values = array
            for _ in 0 ..< (count - array.count) { values.append(0) }
        }
        return values
    }
    
}
