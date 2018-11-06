//**********************************************************//
//                                                          //
//  name: CatsListViewController                            //
//  description: List of cat pictures                       //
//  created: 04/11/2018                                     //
//                                                          //
//**********************************************************//

import UIKit

class CatsListViewController: PictureListViewController {
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listType = .Cats
    }
}

