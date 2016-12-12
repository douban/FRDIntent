//
//  FRDIntentTypealias.swift
//  FRDIntent
//
//  Created by bigyelow on 12/12/2016.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

import Foundation

public typealias URLRoutesHandlerParam = [String: AnyObject]
public typealias URLRoutesHandler = (URLRoutesHandlerParam) -> ()
typealias RoutePathNodeValueType = (FRDIntentReceivable.Type?, URLRoutesHandler?)
