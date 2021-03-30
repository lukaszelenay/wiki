//
//  SavedPagesController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 21/03/2021.
//

import Foundation
import CoreData


class SavedPagesController {
    
    public private(set) var savedPagesID: [String] = []
    
    public static let sharedInstance = SavedPagesController()
    
    let managedContext = AppDelegate.delegate.persistentContainer.viewContext
    
    func savePage(pageId: String, pageTitle: String, pageSnippet: String, url: String, completion: @escaping (Bool) -> Void ) {
        if let entity = NSEntityDescription.entity(forEntityName: "WikiPage", in: managedContext),
           let newPage = NSManagedObject(entity: entity, insertInto: managedContext) as? WikiPage {
            newPage.pageID = pageId
            newPage.title = pageTitle
            newPage.snippet = pageSnippet
            newPage.url = url
            savedPagesID.append(pageId)
            //            do {
            ////                if url != "" {
            //                //MARK: TODO: sposob ako ukladat data: https://developer.apple.com/documentation/foundation/urlsessiondownloadtask
            ////                    let URL = NSURL(string: url)
            ////                    let htmlSource = try String(contentsOf: URL! as URL, encoding: String.Encoding.utf8)
            ////                    newPage.html = htmlSource
            ////                }
            //            } catch {
            //                return completion(false)
            //            }
        }
        else {
            //neulozena, nezmenit titulok btn
            return completion(false)
        }
        do {
            try managedContext.save()
            NotificationCenter.default.post(name: NSNotification.Name("refreshUserList"), object: nil)
            //ulozena, zmenit titulok btn
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func deletePage(pageId: String, completion: @escaping (Bool) -> Void){
        
        let fetchRequest: NSFetchRequest<WikiPage> = WikiPage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pageID == %@", pageId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for object in results {
                    managedContext.delete(object as NSManagedObject)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name("refreshUserList"), object: nil)
            completion (true)
        } catch {
            completion (false)
        }
        
    }
    
    
    func getPages() -> [WikiPage] {
        let fetchRequest: NSFetchRequest<WikiPage> = WikiPage.fetchRequest()
        let fetchedResults = try? managedContext.fetch(fetchRequest) as [WikiPage]
        return fetchedResults ?? []
    }
    
    func getAllID(){
        let pages = getPages()
        //zmazem vsetky predtym nacitane id
        if savedPagesID.count != 0 {
            savedPagesID.removeAll()
        }
        savedPagesID.append(contentsOf: pages.compactMap{String($0.pageID!)})
    }
    
    func getPageData(id: String) -> String {
        
        let fetchRequest: NSFetchRequest<WikiPage> = WikiPage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pageID == %@", id)
        let fetchedPage = try? managedContext.fetch(fetchRequest) as [WikiPage]
        if fetchedPage!.count > 0 {
            if let htmlString = fetchedPage![0].html {
                return htmlString
            }
        }
        
        return "NO_DATA"
        
    }
    
}
