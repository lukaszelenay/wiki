//
//  TableViewCell.swift
//  Wiki
//
//  Created by Lukas Zelenay on 21/03/2021.
//

import UIKit
import WebKit

class TableViewCell: UITableViewCell {
    //    private var savedPages = SavedPagesController().savedPagesID
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var snippetText: UILabel!
    
    var page: Page! {
        didSet {
            let pages = SavedPagesController.sharedInstance.savedPagesID
            if let _ = page.fullurl, let pageID = page.pageid, let pageTitle = page.title, let pageSnippet = page.snippet {
                titleLbl.text = pageTitle
                snippetText.text = pageSnippet.html2String + "..."
                //pri opatovnom nacitani vysledkov sa bude zistovat ci su uz ulozene do db
                saveBtn.setTitle(pages.contains("\(pageID)") ? "Delete" : "Save", for: .normal)
            }
        }
    }
    
    var savedPages: WikiPage! {
        didSet {
            if let pageTitle = savedPages.title, let pageSnippet = savedPages.snippet {
                titleLbl.text = pageTitle
                snippetText.text = pageSnippet.html2String + "..."
                saveBtn.setTitle("Delete", for: .normal)
            }
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        //MARK: TO DO - dorobit akciu na stlacenie btn z SavedViewController, tato sa vykona pri stlaceni v SearchViewController
        if self.saveBtn.titleLabel?.text == "Save" {
            if let selectedPage = page {
                if let pageId = selectedPage.pageid, let title = selectedPage.title, let snippet = selectedPage.snippet, let url = selectedPage.fullurl {
                    let pageIDS = String(pageId)
                    SavedPagesController.sharedInstance.savePage(pageId: pageIDS, pageTitle: title, pageSnippet: snippet, url: url) { [weak self] uspech in
                        if uspech {
                            self?.saveBtn.setTitle("Delete", for: .normal)
                            SavedPagesController.sharedInstance.getAllID()
                        }
                    }
                }
            }
        }
        else {
            //je ulozena
            if let selectedPage = page {
                if let pageId = selectedPage.pageid {
                    let pageIDS = String(pageId)
                    SavedPagesController.sharedInstance.deletePage(pageId: pageIDS) { [weak self] uspech in
                        if uspech {
                            self?.saveBtn.setTitle("Save", for: .normal)
                            SavedPagesController.sharedInstance.getAllID()
                        }
                    }
                }
            } else {
                if let selectedPage = savedPages {
                    if let pageID = selectedPage.pageID {
                        let pageIDS = String(pageID)
                        SavedPagesController.sharedInstance.deletePage(pageId: pageIDS) { uspech in
                            if uspech {
                                SavedPagesController.sharedInstance.getAllID()
                            }
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
