//
//  WebDataProvider.swift
//  Wiki
//
//  Created by Lukas Zelenay on 18/03/2021.
//

import Foundation


final class WebDataProvider {
    
    static let shared = WebDataProvider()

}

extension WebDataProvider {
    
    func fetchData(searchedText: String, gsroffset: Int, completionHandler: @escaping([Page]) -> Void) {
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
        
        
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=info&continue=gsroffset%7C%7C&generator=search&inprop=url&gsrsearch=\(searchedText)&gsroffset=\(gsroffset)&gsrprop=snippet"
        
        guard let url = URL(string: urlString) else {
               print("Bad URL: \(urlString)")
               return
           }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: jsonData) {
                    fetchedPages = Array(items.query.pages.values)
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

