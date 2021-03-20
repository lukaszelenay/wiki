//
//  WebDataProvider.swift
//  Wiki
//
//  Created by Lukas Zelenay on 18/03/2021.
//

import Foundation


final class WebDataProvider {
    
    static let shared = WebDataProvider()
    public var pages = [Page]()

}

extension WebDataProvider {
    
//    func fetchJsonData(searchedText: String, completionHandler: @escaping([Result]) -> Void) {
//        var fetchedPages = [Result]()
//        
//        let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&continue=gsroffset%7C%7C&generator=search&inprop=url&gsrsearch=\(searchedText)&gsroffset=0&gsrprop=snippet"
//        
//        guard let urlToServer = URL.init(string: urlString) else {
//            print("Bad request")
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: {(data, response, error) in
//            if error != nil || data == nil {
//                print("An error occured while fetching data from API")
//            }
//            else {
//                if let responseText = String.init(data: data!, encoding: .ascii) {
//                    let jsonData = responseText.data(using: .utf8)!
//                    fetchedPages = try! JSONDecoder().decode([Result].self, from: jsonData)
//                    completionHandler(fetchedPages)
//                }
//            }
//        })
//        
//        task.resume()
//    }
    
    func fetchData(searchedText: String, completionHandler: @escaping([Page]) -> Void) {
        var fetchedPages = [Page]()
        //MARK: TODO - tento format zapisu sa mi viac paci(It's longer code, but easier to read.)
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "en.wikipedia.org"
//        components.path = "/w/api.php"
//        components.queryItems = [
//            URLQueryItem(name: "action", value: "query"),
//            URLQueryItem(name: "prop", value: "info"),
//            URLQueryItem(name: "continue", value: "gsroffset%7C%7C"),
//            URLQueryItem(name: "generator", value: "search"),
//            URLQueryItem(name: "inprop", value: "url"),
//            URLQueryItem(name: "gsrsearch", value: "\(searchedText)"),
//            URLQueryItem(name: "format", value: "json"),
//            URLQueryItem(name: "gsroffset", value: "0"),
//            URLQueryItem(name: "gsrprop", value: "snippet")
//        ]
//        print(components.url ?? "Bad URL.")
        
        //MARK: TODO - dorobit strankovanie cez premennu gsroffset=0 a navysovat o 10
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&continue=gsroffset%7C%7C&generator=search&inprop=url&gsrsearch=\(searchedText)&gsroffset=0&gsrprop=snippet"
        
        // prop=extracts
        //let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro&explaintext&continue=gsroffset%7C%7C&generator=search&gsrsearch=\(searchedText)&gsroffset=0"
        
        
        
        
        guard let url = URL(string: urlString) else {
               print("Bad URL: \(urlString)")
               return
           }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: jsonData) {
                    
                    fetchedPages = Array(items.query.pages.values)
                    print("Data was parsed.")
                    completionHandler(fetchedPages)
                    
                }
                else {
                    print("Failed to parse data.")
                }
                return
            }
        }.resume()
    }
    
}

