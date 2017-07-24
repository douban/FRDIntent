//
//  FRDIntentParameters.swift
//  FRDIntent
//
//  Created by GUO Lin on 04/01/2017.
//  Copyright © 2017 Douban Inc. All rights reserved.
//

import Foundation

/**
 * Open the parameters to public.
 * Defined as a class because of the usage of Objective-C.
 */
public class FRDIntentParameters: NSObject {

  /// The usual keys to get the infomation from extras of intent.
  public static let title = "FRDIntentTitleKey"
  public static let hidesBottomBarWhenPushed = "FRDIntentHidesBottomBarWhenPushedKey"
  public static let URL = RouteManager.URLRouteURL

  // Extract the ":id" pattern match from intent's extras.
  // swiftlint:disable:next identifier_name
  public static let id = "id"
}
