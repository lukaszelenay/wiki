//
//  SavedViewController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 18/03/2021.
//

import UIKit

class SavedViewController: UIViewController {
    
    let refreshControll = UIRefreshControl()
    var pages: [WikiPage] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControll)
        //register prototype cell
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("refreshUserList"), object: nil)

//        print(pages[0].title)
//        print(pages.count)
        
        tableView.delegate = self
        tableView.dataSource = self
        refresh()
    }
    
    @objc func refresh() {
        pages = SavedPagesController.sharedInstance.getPages()
        tableView.reloadData()
        refreshControll.endRefreshing()
    }


}


extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        //cell.page = self.pages[indexPath.row]
        
        cell.saveBtn.setTitle("Delete", for: .normal)
        cell.titleLbl.text = pages[indexPath.row].title
        cell.snippetText.text = pages[indexPath.row].snippet?.html2String
        return cell
    }
    
    
}
