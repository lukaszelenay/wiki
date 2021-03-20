//
//  ViewController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 18/03/2021.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    private let webDataProvider = WebDataProvider()
    
    @IBAction func changeValueSearchTF(_ sender: UITextField) {
        if searchTF.text != "" {
            searchBtn.isEnabled = true
        } else {
            searchBtn.isEnabled = false
        }
    }
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showSearchBtnAction(_ sender: Any) {
        //skryjem klavesnicu, metoda sa vola nad zakladnym view, tu je jedno aky element drzi klavesnicu otvorenu
        self.view.endEditing(true)
        
        if let text = searchTF.text {
            webDataProvider.fetchData(searchedText: text, completionHandler: { fetchedPages in
                self.pages = fetchedPages
                
            })
        }
        setTableView()
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBtn.isEnabled = false
        searchTF.delegate = self
        
        
        
        //Pri cisteni odmazat nasledujucu funkciu aj s jej kodom
        //parseJSON()
    }
    
    
    private var pages = [Page]()
    {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func parseJSON() {
        //nacitam ulozeny subor
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            if let items = try? decoder.decode(Result.self, from: jsonData) {
                self.pages = Array(items.query.pages.values)
            }
            else {
                print("Failed to parse data.")
            }
            return
        }
        catch {
            print("Error: \(error)")
        }
    }
    
    @discardableResult func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTF.text != "" {
            showSearchBtnAction((Any).self)
        }
        return true
    }
    
    func setTableView() {
        //MARK: TODO: Doriesit po spusteni sa tam nechcem hned dostat, volat samostatne neskor
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebViewController, let page = sender {
            destinationVC.selectedUrl = page as? String
        }
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: TODO: Doriesit
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        if let title = self.pages[indexPath.row].title, let text = self.pages[indexPath.row].snippet {
//            print(text)
            cell.textLabel?.text = title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSelectedWebResult", sender: pages[indexPath.row].fullurl)
    }
    
}
