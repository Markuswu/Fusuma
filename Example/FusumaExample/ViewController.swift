//
//  ViewController.swift
//  Fusuma
//
//  Created by ytakzk on 01/31/2016.
//  Copyright (c) 2016 ytakzk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FusumaDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var fileUrlLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showButton.layer.cornerRadius = 2.0
        self.fileUrlLabel.text = ""
        
        fusumaImageOverlayBrightness = 0.88
        fusumaLongPressPhotoLibCellEnabled = true
//        fusumaTextColors = [UIColor.white, UIColor.black, UIColor.magenta, UIColor.blue, UIColor.purple, UIColor.brown]
        fusumaBackgroundColor = UIColor.white
        fusumaBaseTintColor = UIColor.black
        fusumaSelectedColor = UIColor.black
        fusumaDeselectColor = UIColor.lightGray
        fusumaIndicatorColor = UIColor.red
        fusumaShowDoneButtonOnLibraryOnly = true
        fusumaCameraZoomInEnabled = true
        fusumaPrefersStatusBarHidden = true
        fusumaAutoDismiss = true
        fusumaAlbumName = "My Images"
        
        fusumaTextColors = Array(repeating: UIColor.magenta, count: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showButtonPressed(_ sender: AnyObject) {
        // Show Fusuma
        
        let fusuma = FusumaViewController()
        fusuma.initialSelectedColorIndex = 3
        
        //        fusumaCropImage = false
        
        if #available(iOS 11.0, *) {
            fusuma.safeAreaInsets = self.view.safeAreaInsets
        }
        fusuma.photoEditable = false
        fusuma.saveAsScreenshoot = true
        fusuma.statusBarHeight = 0
        fusuma.photoCamOption = .noVideo
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusumaSavesImage = true
        
        fusuma.modalPresentationStyle = .fullScreen

        self.present(fusuma, animated: true, completion: nil)
    }
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        
        imageView.image = image
        
        FusumaViewController.shared.clearEditText()
    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        FusumaViewController.shared.present(alert, animated: true, completion: nil)
    }
    
    func fusumaWillPresentPhotosLib(_ fusumaVC: FusumaViewController) {
        //
    }
    
    func fusumaDidDismissPhotosLib(_ fusumaVC: FusumaViewController) {
        //
    }

}

