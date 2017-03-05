//
//  PhotoViewController.swift
//  Labb1Swift
//
//  Created by Wilhelm Fors on 05/03/17.
//  Copyright © 2017 Wilhelm Fors. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var id : Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
        } else {
            print("No saved photo")
        }
        
        refreshGUI()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        }
        
        present(picker, animated: true, completion: {})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                let url = URL(fileURLWithPath: imagePath)
                try data.write(to: url)
                print("\(imagePath)")
            } catch {
                print("Something went wrong")
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
        if let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
        } else {
            print("No saved photo")
        }

    }
    
    var imagePath : String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory.appending("food\(id).png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshGUI() {
        UIView.animate(withDuration: 0.20, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.view.backgroundColor = UIColor.green
        }) {
            finished in
            UIView.animate(withDuration: 0.20, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.view.backgroundColor = UIColor.red
            }) {
                finished in
                self.refreshGUI()
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
