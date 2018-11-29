//
//  FRDInitializerHelper.swift
//  FRDIntent
//
//  Created by mugua on 2018/11/28.
//  Copyright © 2018 Douban Inc. All rights reserved.
//

import UIKit

class FRDInitializerHelper {
    
    static func viewController(fromClazz clazz: FRDIntentReceivable.Type?, extras: [String: Any]) -> FRDIntentReceivable? {
        
        guard let controllerClass = clazz else { return nil }
        return controllerClass.init(extras: extras)
    }
}
