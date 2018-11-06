//**********************************************************//
//                                                          //
//  name: DogsListViewController                            //
//  description: List of dog pictures                       //
//  created: 04/11/2018                                     //
//                                                          //
//**********************************************************//

import UIKit

class DogsListViewController: PictureListViewController {
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listType = .Dogs
    }
}

