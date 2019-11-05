//
//  SuperHerosProtocols.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

protocol ServiceHandlerProtocol {
    func getDataFromServer(key: String?)
}
protocol TableViewReload: class {
    var  reloadTableViewWithSection: ((Int?) -> ())? { get set }
}
protocol TableViewDataHandlerProtocol: class {
    func numberOfSections() -> Int
    func numberOfRowsInASection(section: Int) -> Int
    func getDataForIndexPath(indexPath: IndexPath) -> [String: Any]
    func refreshDataHandler()
    func titleForHeaderInSection(section: Int) ->String
}

protocol SuperHerosViewModelProtocol: ServiceHandlerProtocol, TableViewDataHandlerProtocol {
    var arrayOfYears: [String] { get }
    var currentSelectedYear: Int { get }
    var arrayModels: [SuperHerosModelProtocol] { get set }
    func checkInCacheAndFetchResults()
    func getCurrentSelectedYear()-> String
}
extension SuperHerosViewModelProtocol {
    var arrayOfYears: [String] {
        get {
            return ["2006", "2009", "2012", "2015", "2018"]
        }
    }
}
protocol SuperHerosNerWorkProtocol {
    func getDataFromServer(year: String,  completion: @escaping (([String: Any]?, Error? ) -> Void))
}
protocol SuperHerosModelProtocol {
    var Name: String { get set }
    var Picture: String { get set }
    var Score: Int { get set  }
}
