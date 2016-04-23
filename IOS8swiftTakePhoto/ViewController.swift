//
//  ViewController.swift
//  IOS8swiftTakePhoto
//
//  Created by John Ko on 2/20/16.
//  Copyright © 2016 John Ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func CameraAction(sender: UIButton) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        print("after camrea action")
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
        test(ImageDisplay.image)
    }
    
    func abc(items: [String]) {
        print("hi")
    }
    
    func test(image : UIImage?) {
        let taggingAPI = TaggingAPI()
        taggingAPI.postImage(image, callback: abc)
        
        //let request = Request(url:"https://www.johnko.org/ios/index.php")
        //request.post(image, completion: callback)
        //let request = Request(method:"POST", url:"https://api.imagga.com/v1/content")

        //request.getTags("8590b308521bc07fa295c60fb3d889fa")
        //request.getTags("c32c08ed3291e76e9e216f4c5c5fedbe")
        
        //request.post(image, completion: callback)
        
    }
    
    func callback() {
        let alertController = UIAlertController(title: "iOScreator", message:
            "Hello, world!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

