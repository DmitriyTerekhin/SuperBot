//
//  CustomSlider.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class CustomSlider: UISlider {
    
    private let trackHeight: CGFloat = 5

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: trackHeight))
    }
    
    private let thumbWidth: Float = 54
    lazy var startingOffset: Float = 0 - (thumbWidth)
    lazy var endingOffset: Float = thumbWidth * 1.5
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let xTranslation =  startingOffset + (minimumValue + endingOffset) / maximumValue * value
        return super.thumbRect(forBounds: bounds, trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation), y: 0)), value: value)
    }
    
}
