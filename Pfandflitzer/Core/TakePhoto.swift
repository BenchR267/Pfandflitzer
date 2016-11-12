//
//  TakePhotoVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import RxSwift

class TakePhoto: NSObject {
    
    static var canTakePhoto: Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    var imageVariable = Variable<UIImage?>(nil)
    var strongSelf: TakePhoto?
    
    func show(on controller: UIViewController) -> Observable<UIImage> {
        self.strongSelf = self
        let c = UIImagePickerController()
        c.sourceType = .camera
        c.delegate = self
        controller.present(c, animated: true, completion: nil)
        return imageVariable.asObservable().filterNil()
    }
    
}

extension TakePhoto: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageVariable.value = image
        }
        picker.dismiss(animated: true) {
            self.strongSelf = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.strongSelf = nil
        }
    }
}
