//
//  LifeProgressWidgetBundle.swift
//  LifeProgressWidget
//
//  Created by yuki on R 7/04/06.
//

import WidgetKit
import SwiftUI

@main
struct LifeProgressWidgetBundle: WidgetBundle {
    var body: some Widget {
        LifeProgressWidget()
        LifeProgressWidgetControl()
        LifeProgressWidgetLiveActivity()
    }
}
