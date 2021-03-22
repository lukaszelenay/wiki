//
//  TableViewCell.swift
//  Wiki
//
//  Created by Lukas Zelenay on 21/03/2021.
//

import UIKit
import WebKit

class TableViewCell: UITableViewCell {
    private var savedPages = SavedPagesController().savedPagesID
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var snippetText: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var page: Page! {
        didSet {
            let pages = SavedPagesController.sharedInstance.savedPagesID
            if let _ = page.fullurl, let pageID = page.pageid, let pageTitle = page.title, let pageSnippet = page.snippet {
                titleLbl.text = pageTitle
                snippetText.text = pageSnippet.html2String
                //pri opatovnom nacitani vysledkov sa bude zistovat ci su uz ulozene do db
//                let idPage = pageID as! String
                saveBtn.setTitle(pages.contains("\(pageID)") ? "Delete" : "Save", for: .normal)
            }
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if self.saveBtn.titleLabel?.text == "Save" {
            if let selectedPage = page {
                if let pageId = selectedPage.pageid, let title = selectedPage.title, let snippet = selectedPage.snippet, let url = selectedPage.fullurl {
                    let pageIDS = String(pageId)
                    SavedPagesController().savePage(pageId: pageIDS, pageTitle: title, pageSnippet: snippet, url: url) { [weak self] uspech in
                        if uspech {
                            self?.saveBtn.setTitle("Delete", for: .normal)
                            SavedPagesController.sharedInstance.getAllID()
                        }
                    }
                }
            }
        }
        else {
            if let selectedPage = page {
                if let pageId = selectedPage.pageid {
                    let pageIDS = String(pageId)
                    SavedPagesController().deletePage(pageId: pageIDS) { [weak self] uspech in
                        if uspech {
                            self?.saveBtn.setTitle("Save", for: .normal)
                            SavedPagesController.sharedInstance.getAllID()
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
