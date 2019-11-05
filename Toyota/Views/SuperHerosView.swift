//
//  SuperHerosView.swift
//  Toyota
//
//  Created by Gnana Thallaparthy on 03/11/19.
//  Copyright © 2019 Epam. All rights reserved.
//

import UIKit

final class SuperHerosView: UIView {
    
    // MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Props and Instance vars
    private var numberOfSections = 0
    private var numberOfRows: Int = 0
    private var data: [[String: Any]] = []
    var refreshControl =  UIRefreshControl()
    weak var delegate: TableViewDataHandlerProtocol!
    
    init(_ delegate: TableViewDataHandlerProtocol, frame: CGRect) {
        super.init(frame: frame)
        self.delegate = delegate
        self.addXibToView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func addXibToView() {
        let view = Bundle.main.loadNibNamed(Xibs.SuperHerosView, owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        self.setupTableView()
    }
    private func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        self.tableView.register(UINib.init(nibName: Xibs.SuperHeroCell, bundle: nil
        ), forCellReuseIdentifier: CellIdentifiers.SUPERHERO_CELL)
        let footerView = UIView.init(frame: .zero)
        self.tableView.tableFooterView = footerView
    }
    @objc func refresh(_ sender: AnyObject) {
        self.delegate.refreshDataHandler()
        self.refreshControl.endRefreshing()
    }
    func reloadData() {
        self.tableView.reloadData()
    }
}
extension SuperHerosView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension SuperHerosView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.numberOfRowsInASection(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getSuperHerosCell(indexPath: indexPath)
    }
    private func getSuperHerosCell(indexPath: IndexPath) -> SuperHeroCell {
        let cellSuperHeros = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SUPERHERO_CELL, for: indexPath) as! SuperHeroCell
        cellSuperHeros.uploadData(self.delegate.getDataForIndexPath(indexPath: indexPath))
        return cellSuperHeros
    }
//    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String {
//      return delegate
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate.titleForHeaderInSection(section: section)
    }
    
    func tableView (tableView:UITableView , heightForHeaderInSection section:Int)->Float
    {
        
        var title = self.tableView(tableView, titleForHeaderInSection: section)
        if (title == "") {
            return 0.0
        }
        return 40.0
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25.0)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
}
