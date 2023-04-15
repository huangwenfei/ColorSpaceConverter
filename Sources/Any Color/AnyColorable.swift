//
//  AnyColorable.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public struct AnyColorable {
    
    /// The value wrapped by this instance.
    public private(set) var base: Any

    /// Creates a type-erased colorable value that wraps the given instance.
    ///
    /// - Parameter base: A colorable value to wrap.
    public init<H>(_ base: H) where H : Colorable {
        self.base = base
    }

}
