//
//  Camera.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import MobileCoreServices

class Camera {
    
    class func shouldStartCamera(target: AnyObject, canEdit: Bool, frontFacing: Bool) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == false {
            return false
        }
        
        let type = kUTTypeImage as String
        let cameraUI = UIImagePickerController()
        
        let available = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) && (UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.camera)?.contains(type))!
        
        if available {
            cameraUI.mediaTypes = [type]
            cameraUI.sourceType = UIImagePickerController.SourceType.camera
            
            /* Prioritize front or rear camera */
            if (frontFacing == true) {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerController.CameraDevice.front
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerController.CameraDevice.rear
                }
            } else {
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                    cameraUI.cameraDevice = UIImagePickerController.CameraDevice.rear
                } else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front) {
                    cameraUI.cameraDevice = UIImagePickerController.CameraDevice.front
                }
            }
        } else {
            return false
        }
        
        cameraUI.allowsEditing = canEdit
        cameraUI.showsCameraControls = true
        if target is ChatViewController {
            cameraUI.delegate = target as! ChatViewController
        }
//        else if target is ProfileViewController {
//            cameraUI.delegate = target as! ProfileViewController
//        }
        target.present(cameraUI, animated: true, completion: nil)
        
        return true
    }
    
    class func shouldStartPhotoLibrary(target: AnyObject, canEdit: Bool) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            return false
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) && (UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.photoLibrary)?.contains(type))!{
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) && (UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.savedPhotosAlbum)?.contains(type))!{
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        }
        else {
            return false
        }
        
        imagePicker.allowsEditing = canEdit
        if target is ChatViewController {
            imagePicker.delegate = target as! ChatViewController
        }
//        else if target is ProfileViewController {
//            imagePicker.delegate = target as! ProfileViewController
//        }
        target.present(imagePicker, animated: true, completion: nil)
        
        return true
    }
    
    class func shouldStartVideoLibrary(target: AnyObject, canEdit: Bool) -> Bool {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            return false
        }
        
        let type = kUTTypeMovie as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) && (UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.photoLibrary)?.contains(type))!{
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) && (UIImagePickerController.availableMediaTypes(for: UIImagePickerController.SourceType.savedPhotosAlbum)?.contains(type))!{
            imagePicker.mediaTypes = [type]
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        }
        else {
            return false
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = target as! ChatViewController
        target.present(imagePicker, animated: true, completion: nil)
        
        return true
    }
}
