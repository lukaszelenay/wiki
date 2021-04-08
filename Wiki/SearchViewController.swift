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
    private var pages = [Page]()
    {
        didSet {
            //DispatchQueue riadi vykonavanie uloh, v tomto pripade asynchronne vykonanie
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func changeValueSearchTF(_ sender: UITextField) {
        searchBtn.isEnabled = searchTF.text?.isEmpty == false
//        searchTF.text != "" ? (searchBtn.isEnabled = true) : (searchBtn.isEnabled = false)
    }
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showSearchBtnAction(_ sender: Any) {
        //skryjem klavesnicu, metoda sa vola nad zakladnym view, tu je jedno aky element drzi klavesnicu otvorenu
        self.view.endEditing(true)
        
        if let text = searchTF.text?.urlEncoded {
            if searchedText == text {
                searchData(search: text, gsroffset: gsroffset)
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
        //pri prvom spusteni nacitam vsetky id ulozenych clankov z db
        SavedPagesController.sharedInstance.getAllID()
        
        //register prototype cell
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        searchBtn.isEnabled = false
        searchTF.delegate = self
        //skryjem prazdne tableView
        tableView.isHidden = true
    }
    
    
    
    //MARK: funkcia na parsovanie JSON dat z lokalneho uloziska
//    private func parseJSON() {
//        //nacitam ulozeny subor
//        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {
//            return
//        }
//
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            let jsonData = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//
//            if let items = try? decoder.decode(Result.self, from: jsonData) {
//                self.pages = Array(items.query.pages.values)
//            }
//            else {
//                print("Failed to parse data.")
//            }
//            return
//        }
//        catch {
//            print("Error: \(error)")
//        }
//    }
    
    //akcia, ktora sa vykona po stlaceni klavesy Search na klavesnici
    @discardableResult func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTF.text != "" {
            showSearchBtnAction((Any).self)
        }
        return true
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        //odkryjem tableView
        tableView.isHidden = false
    }
    
    //priprava vykonania segue, sender obsahuje hodnotu z pages[indexPath.row].fullurl, ktora sa odoslala z delegatnej metody didSelectRowAt
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebViewController, let page = sender {
            destinationVC.selectedUrl = page as? String
        }
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    //willDisplay zabezpeci strankovanie, ak bude pocet riadkov, ktore sa maju zobrazit menej ako 2 tak sa zavola funkcia na nacitanie vysledkov
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index: Int = indexPath.row
        if (gsroffset - index) < 2 {
            searchData(search: searchedText, gsroffset: gsroffset)
        }
    }
    
    //strankovanie vysledkov na api je cez parameter gsroffset, 0 - prvych 10 vysledkov, 10 dalsich 10....
    //na jeho automaticku inkrementaciu mozem pouzit pocet prvkov pola s nacitanymi strankami
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gsroffset = pages.count
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.page = self.pages[indexPath.row]
        return cell
    }
    
    //inicializujem prechod do noveho okna s url vybraneho clanku
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showSelectedWebResult", sender: pages[indexPath.row].fullurl)
    }
    
}
