//
//  ViewController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 18/03/2021.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    private let webDataProvider = WebDataProvider()
    private var gsroffset = 0
    private var searchedText = ""
    
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
            if searchedText == text {
                searchData(search: searchedText, gsroffset: gsroffset)
            } else {
                searchedText = text
                gsroffset = 0
                pages.removeAll()
                searchData(search: searchedText, gsroffset: gsroffset)
            }
        }
        setTableView()
    }
    
    func searchData(search text: String, gsroffset: Int ){
        webDataProvider.fetchData(searchedText: text, gsroffset: gsroffset, completionHandler: { fetchedPages in
            self.pages += fetchedPages
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //register prototype cell
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
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
    
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index: Int = indexPath.row
        if (gsroffset - index) < 2 {
            searchData(search: searchedText, gsroffset: gsroffset)
        }
    }
    
    //MARK: TODO: Doriesit
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gsroffset = pages.count
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        if let title = self.pages[indexPath.row].title, let snippetText = self.pages[indexPath.row].snippet {

            cell.titleLbl.text = title
            cell.snippetText.text = snippetText.html2String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSelectedWebResult", sender: pages[indexPath.row].fullurl)
    }
    
}
