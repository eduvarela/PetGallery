//**********************************************************//
//                                                          //
//  name: ListViewController                                //
//  description: base class for the picture list behavior   //
//  created: 04/11/2018                                     //
//                                                          //
//**********************************************************//

import UIKit

class PictureListViewController: UITableViewController {
    
    //MARK: Attributes
    var pictureList: [PictureItem] = []
    var listType: PictureType? = nil
    
    //MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //notification observer for pictures update
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidReceivePicture(notification:)), name: .didReceivePicture, object: nil)

    }
    //MARK: Update Data
    
    //function that update picture list after receiving them
    @objc func onDidReceivePicture(notification:Notification) {
        
        if let data = notification.userInfo as? [String : PictureItem]
        {
            if let pictureItem: PictureItem = data["picture"] as? PictureItem{
                
                //Check if the type of picture is the same as the list
                if(pictureItem.type == listType){
                    pictureList.append(pictureItem)
                    
                    //Notify the main thread to update tableView
                    DispatchQueue.main.async {
                        self.tableView.insertRows(at: [IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)], with: .automatic)
                    }
                    
                }
            }
      
        }
    }
    
    //MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictureList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pictureCell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath)
        
        let imageView: UIImageView = pictureCell.viewWithTag(1) as! UIImageView
        imageView.image = pictureList[indexPath.row].image
        return pictureCell
    }

}
