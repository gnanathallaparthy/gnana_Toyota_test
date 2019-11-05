//
//  CommonNetWorkHandler.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

enum NetWorkErrors: String, Error {
    case invalidURl = "InvalidURL"
}

final class CommonNetworkHandler {
    
    static func commonPostMethod(urlRequest: URLRequest,
                                  completion: @escaping NetWorkResponseClosure) {
        let session = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
        session.resume()
    }
}
