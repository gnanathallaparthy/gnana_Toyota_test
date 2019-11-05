//
//  UIViewExtension.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return (self.statusCode >= 200 && self.statusCode <= 300)
    }
}
