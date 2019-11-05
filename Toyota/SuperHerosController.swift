//
//  ViewController.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 02/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import UIKit

final class SuperHerosController: UIViewController {
    
    var viewSuperHeros: SuperHerosView!
    var viewModelSuperHeros = SuperHerosViewModel(SuperHerosNetWorkHandler())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSuperHeros = SuperHerosView(self, frame: self.view.bounds)
        self.view.addSubview(viewSuperHeros)
        self.initialSetup()
    }
    private func initialSetup() {
        viewSuperHeros.delegate = self
        viewModelSuperHeros.reloadTableViewWithSection = { [weak self] index in
            DispatchQueue.main.async {
                self?.viewSuperHeros.reloadData()
            }
        }
        viewModelSuperHeros.checkInCacheAndFetchResults()
    }
}
extension SuperHerosController: TableViewDataHandlerProtocol {
    func titleForHeaderInSection(section: Int) -> String {
        return viewModelSuperHeros.titleForHeaderInSection(section: section)
    }
    
    
    func numberOfSections() -> Int {
        return viewModelSuperHeros.numberOfSections()
    }
    func numberOfRowsInASection(section: Int) -> Int {
        return viewModelSuperHeros.numberOfRowsInASection(section: section)
    }
    func getDataForIndexPath(indexPath: IndexPath) -> [String: Any] {
        return viewModelSuperHeros.getDataForIndexPath(indexPath: indexPath)
    }
    func refreshDataHandler() {
        viewModelSuperHeros.refreshDataHandler()
    }
}


