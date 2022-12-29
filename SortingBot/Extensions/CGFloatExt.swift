//
//  CGFloatExt.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 07.12.2022.
//

import UIKit

extension CGFloat {
    
    var dp: CGFloat {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return (self / 375) * UIScreen.main.bounds.width
        } else {
            return (self / 375) * UIScreen.main.bounds.height
        }
    }
    
    var iPadDP: CGFloat {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return (self / 769) * UIScreen.main.bounds.width
        } else {
            return (self / 769) * UIScreen.main.bounds.height
        }
    }
}

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}
