//**********************************************************//
//                                                          //
//  name: PictureManager                                    //
//  description: Class that retrieve pictures from API      //
//  created: 04/11/2018                                     //
//                                                          //
//**********************************************************//

import UIKit

class PictureManager {
    //MARK: Attributes
    static let apiKey = "8fcb6310-cd7c-4563-91e8-b040d813ed14"
    static let catsUrl = URL(string: "https://api.thecatapi.com/v1/images/search")
    static let dogsUrl = URL(string: "https://api.thedogapi.com/v1/images/search")
    static let requestList = DispatchGroup()
    
    //MARK: Data Retrieving
    //TODO: can be parameterized
    static func requestPictures(){
        //request 25 cat pictures
        for _ in 1...25 {
            PictureManager.requestList.enter()
            PictureManager.requestImage(type: .Cats)
        }
        //request 50 dog pictures
        for _ in 1...50 {
            PictureManager.requestList.enter()
            PictureManager.requestImage(type: .Dogs)
        }
    }
    
    static func requestImage(type: PictureType){
        let url = type == .Cats ? catsUrl! : dogsUrl!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                //check for network errors
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                //check if request has been successfully
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("response = \(String(describing: response))")
                }
                
                //gathering the picture
                
                //Deserialize json as a PictureData Object
                let picture: [PictureData] = try! JSONDecoder().decode([PictureData].self, from: data).compactMap { $0 }
                let pictureUrl = URL(string: (picture.first?.url)!)
                let pictureImage = try! UIImage(data: Data(contentsOf: pictureUrl!))
              
                NotificationCenter.default.post(name: .didReceivePicture, object: self, userInfo: ["picture": PictureItem(image: pictureImage!, type: type)])
            }
            task.resume()
    }
}

//MARK: Custom Types


//type of pictures
enum PictureType{
    case Cats
    case Dogs
}

struct PictureData: Codable {
    var url: String
}

struct PictureItem {
    var image: UIImage
    var type: PictureType
}

//MARK: Notifications
extension Notification.Name{
    static let didReceivePicture = Notification.Name("didReceivePicture")
}

