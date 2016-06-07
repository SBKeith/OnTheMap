//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/7/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}