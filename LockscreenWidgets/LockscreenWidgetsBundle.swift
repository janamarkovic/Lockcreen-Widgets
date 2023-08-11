//
//  LockscreenWidgetsBundle.swift
//  LockscreenWidgets
//
//  Created by Jana Markovic on 30.11.22..
//

import WidgetKit
import SwiftUI

@main
struct LockscreenWidgetsBundle: WidgetBundle {
    var body: some Widget {
        LockscreenWidgets()
        LockscreenWidgetsLiveActivity()
    }
}
