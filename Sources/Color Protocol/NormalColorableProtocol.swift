//
//  NormalColorableProtocol.swift
//  ColorSpaceConverter
//
//  Created by 黄文飞 on 2023/4/15.
//

import Foundation

public protocol NormalColorableProtocol: Colorable {
    var illuminant: Illuminant { get set }
}
