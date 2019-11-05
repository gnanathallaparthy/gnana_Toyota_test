//
//  SuperoHerosViewModel.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import Foundation

class SuperHerosViewModel: SuperHerosViewModelProtocol {
    
    var reloadTableViewWithSection: ((Int?) -> ())?
    var currentSelectedYear: Int = 0
    var netWorkHandler: SuperHerosNerWorkProtocol
    var arrayModels: [SuperHerosModelProtocol] = [] {
        didSet {
            self.reloadTableViewWithSection?(nil)
        }
    }
    init(_ netWorkHandler: SuperHerosNerWorkProtocol) {
        self.netWorkHandler = netWorkHandler
    }
    func getCurrentSelectedYear() -> String {
        var year: String = ""
        if(currentSelectedYear < arrayOfYears.count) {
            year = arrayOfYears[currentSelectedYear]
        } else {
            year = arrayOfYears[0]
            currentSelectedYear = 0
        }
        return year
    }
    func checkInCacheAndFetchResults() {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileUrl = tempDirectory.appendingPathComponent("Superheros").appendingPathExtension("json")
        let filePath = fileUrl.path
        if(FileManager.default.fileExists(atPath: filePath)) {
            let data = try? Data(contentsOf: fileUrl, options: .uncached)
            guard let unWrappedData = data else { return }
            let jsonDict = try? JSONSerialization.jsonObject(with: unWrappedData, options: .allowFragments) as? [String: Any]
            guard let unWrappedDict = jsonDict else { return }
            let key = URLS.BaseURL + getCurrentSelectedYear()
            let heroesDict = unWrappedDict[key] as? [String: Any]
            if(heroesDict != nil) {
                self.parseDataFromDict(heroesDict)
            } else {
                self.getDataFromServer(key: nil)
            }
        } else {
            self.getDataFromServer(key: nil)
        }
    }
    func getDataForIndexPath(indexPath: IndexPath) -> [String : Any] {
        let model = arrayModels[indexPath.row]
        var dictToBeReturned: [String : Any] = [: ]
        dictToBeReturned[Keys.Name] = model.Name
        dictToBeReturned[Keys.Picture] = model.Picture
        dictToBeReturned[Keys.Score] = model.Score
        return dictToBeReturned
    }
    func getDataFromServer(key: String?) {
        let year = self.getCurrentSelectedYear()
        let completion = { [unowned self] (dict: [String: Any]?, error: Error?) in
            self.parseDataFromDict(dict)
            self.setDataInCache(year, dict)
        }
        netWorkHandler.getDataFromServer(year: year, completion: completion)
    }
    func setDataInCache(_ key: String, _ dict: [String: Any]?) {
        let tempFolder = FileManager.default.temporaryDirectory
        let filePath = tempFolder.appendingPathComponent("Superheros").appendingPathExtension("json")
        if(!FileManager.default.fileExists(atPath: filePath.path)) {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        }
        let data = try? Data(contentsOf: filePath, options: .uncached)
        var resultDict: [String: Any] = [: ]
        if let unWrappedData = data {
            let dictOptional =  try? JSONSerialization.jsonObject(with: unWrappedData, options: .allowFragments) as? [String: Any]
            resultDict = dictOptional ?? [: ]
        }
        let key = URLS.BaseURL + key
        resultDict[key] = dict
        let dataToWrite = try! JSONSerialization.data(withJSONObject: resultDict, options: .prettyPrinted)
        try? dataToWrite.write(to: filePath)
    }
    func parseDataFromDict(_ dict: [String: Any]?) {
        guard let unWrappedDict = dict,
            let heroesArray = unWrappedDict[Keys.Heroes] as? [[String: Any]] else { return }
        self.arrayModels = []
        let jsonDecoder = JSONDecoder()
        let unfilteredModels:[SuperHerosModelProtocol] = heroesArray.map({ [unowned self] dictHero in
            let data = try? JSONSerialization.data(withJSONObject: dictHero, options: .prettyPrinted)
            guard let unWrappedData = data,
                let model = try? jsonDecoder.decode(SuperHerosModel.self, from: unWrappedData)
                else { return self.getDefaultModel() }
            return model
        })
        self.arrayModels = unfilteredModels.sorted(by:{(modelPrimary,modelSecondary)in
            return modelPrimary.Score > modelSecondary.Score})
    }
    private func getDefaultModel() -> SuperHerosModel {
        let data = try! JSONSerialization.data(withJSONObject: superHeroDefaultModel, options: .prettyPrinted)
        return try! JSONDecoder().decode(SuperHerosModel.self, from: data)
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        return  "\(arrayOfYears[currentSelectedYear])"
    }
    

    // MARK: Basic TableView Protos
    
    func numberOfRowsInASection(section: Int) -> Int {
        if arrayModels.count > 3{
            let topThree = arrayModels.prefix(3)
            return topThree.count
        }else{
            return arrayModels.count
        }
    }
    func numberOfSections() -> Int {
        return 1
    }
    func refreshDataHandler() {
        currentSelectedYear = currentSelectedYear + 1
        self.checkInCacheAndFetchResults()
    }
    
}
