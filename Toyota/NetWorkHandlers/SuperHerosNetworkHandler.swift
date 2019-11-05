//
//  SuperHerosNetworkHandler.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

class SuperHerosNetWorkHandler: SuperHerosNerWorkProtocol {
    
    func getDataFromServer(year: String,  completion: @escaping (([String: Any]?, Error? ) -> Void)) {
        let urlString = URLS.BaseURL + year + ".json"
        let url = URL(string: urlString)
        guard let unWrappedUrl = url else {completion(nil, NetWorkErrors.invalidURl); return }
        
        let urlRequest = URLRequest(url: unWrappedUrl)
        let completion: NetWorkResponseClosure = { [weak self] (data, response, error) in
            guard error == nil else { completion(nil, error); return }
            let httpResponse = response as? HTTPURLResponse
            guard let unWrappedRespose = httpResponse,
                  unWrappedRespose.isSuccess,
                let unWrappedData = data else { return }
            let resposeDict = try? JSONSerialization.jsonObject(with: unWrappedData, options: .allowFragments) as? [String: Any]
            completion(resposeDict, nil)
        }
        CommonNetworkHandler.commonPostMethod(urlRequest: urlRequest, completion: completion)
    }
}
