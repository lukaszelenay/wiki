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
        //register prototype cell
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("refreshUserList"), object: nil)
//        setTableView()
//        tableView.delegate = self
//        tableView.dataSource = self
        refresh()
    }
    
    func setTableView() {
        if pages.count == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        pages = SavedPagesController.sharedInstance.getPages()
        setTableView()
    }
    
    //MARK: WebViewController dostane ID stranky, ktora sa nacita z DB
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebViewController, let pageID = sender {
            destinationVC.selectedPageId = pageID as? String
        }
    }
}


extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
//        cell.saveBtn.setTitle("Delete", for: .normal)
//        cell.titleLbl.text = pages[indexPath.row].title
//        cell.snippetText.text = pages[indexPath.row].snippet?.html2String
        cell.savedPages = pages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSelectedSavedResult", sender: pages[indexPath.row].pageID)
    }
}
