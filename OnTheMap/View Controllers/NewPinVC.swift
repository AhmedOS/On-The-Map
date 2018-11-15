//
//  NewPinVC.swift
//  OnTheMap
//
//  Created by Ahmed Osama on 11/12/18.
//  Copyright © 2018 Ahmed Osama. All rights reserved.
//

import UIKit
import CoreLocation

class NewPinVC: UIViewController {
    
    let mapSegueID = "showMap"
    var activeTextField: UITextField?
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func previewButtonTapped(_ sender: Any) {
        enableUIControllers(false)
        let url = URL(string: linkTextField.text!)
        guard url != nil else {
            Helpers.showSimpleAlert(viewController: self, title: "Error", message: "Invalid Link (URL)")
            enableUIControllers(true)
            return
        }
        getCoordinate(addressString: locationTextField.text!) { (coordinate, error) in
            self.enableUIControllers(true)
            if let error = error {
                Helpers.showSimpleAlert(viewController: self, title: "Invalid Location", message: error.localizedDescription)
                return
            }
            self.coordinate = coordinate
            self.performSegue(withIdentifier: self.mapSegueID, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func enableUIControllers(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.locationTextField.isEnabled = enabled
            self.linkTextField.isEnabled = enabled
            self.previewButton.isEnabled = enabled
            self.cancelButton.isEnabled = enabled
            enabled ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
        }
    }
    
    func getCoordinate(addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == mapSegueID {
            let vc = segue.destination as! PreviewMapVC
            vc.coordinate = coordinate
            vc.mediaURL = linkTextField.text!
        }
    }
    
}

// Keyboard handling
extension NewPinVC {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if activeTextField == linkTextField {
            view.frame.origin.y -= 100//getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

extension NewPinVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField = nil
        textField.resignFirstResponder()
        return true;
    }
}
