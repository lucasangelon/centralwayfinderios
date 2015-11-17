//
//  AboutViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 10/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    private let screen = UIScreen()
    
    override func viewDidLoad() {
        scrollView.delegate = self
        
        textView.editable = false
        scrollView.addSubview(textView)
        
        
        let pageTitle = self.title!
        switch pageTitle {
        case "About":
            textView.text = aboutText
            
        case "Terms of Service":
            textView.text = termsOfServiceText
            
        case "Privacy Policy":
            textView.text = privacyPolicyText
            
        default:
            break
        }
        
        scrollView.sizeThatFits(CGSize(width: screen.applicationFrame.width, height: screen.applicationFrame.height))
    }
    
    final private let aboutText = "Project Sponsors\n\nNeil Fernandes\nAnn Bona\nRob Morgan\n\n\nProject Manager\n\nNichola Kerr\n\n\nDevelopers:\n\nLucas Angelon"
    final private let termsOfServiceText = "The Central Wayfinder software (“The Software”) and the website (“The Website”) for Central Wayfinder are owned by Central Institute of Technology (“The Company”). By using the aforementioned technologies, you acknowledge and confirm that you have read and understood the following terms and conditions (“Terms of Service”). BY ENTERING THIS AGREEMENT ON BEHALF OF A COMPANY OR ANY OTHER LEGAL ENTITY, YOU REPRESENT THAT YOU HAVE THE AUTHORITY AND THEREFORE IS BINDING THE ENTITY, ITS AFFILIATES AND ALL USERS WITH ACCESS TO THE SOFTWARE OR WEBSITE THROUGH YOUR DEVICE TO THE FOLLOWING TERMS AND CONDITIONS, IN WHICH CASE THE TERMS “YOU” OR “YOUR” SHALL REFER TO SUCH ENTITY, ITS AFFILIATES AND USERS. IN CASE YOU DO NOT HAVE SUCH AUTHORITY OR DO NOT AGREE WITH THESE TERMS AND CONDITIONS, YOU MUST NOT ACCEPT THIS AGREEMENT AND MAY NOT USE THE SOFTWARE OR WEBSITE.\n\n\nThe Company reserves the right to update the Terms of Service from time to time at its own discretion and without notice. If The Company makes any changes to these Terms of Service, this document is going to be updated and the Software as well as the Website are going to be updated to contain a copy of these terms. Continued use of the Software and the Website after such changes shall constitute your consent to the changes. You can review the most recently updated version of the Terms of Service at any time in The Website and in The Software.\n\nAny violation of the content outlined in the Terms of Service consists of a breach of agreement and shall be treated accordingly by The Company. You agree to use The Software and The Website at your own risk.\n\n\nA. The Software and The Website Terms\n\na. You expressly understand and agree The Company shall not be held liable for any direct, indirect, incidental, special, consequential or exemplary damages, including but not limited to, damages for loss of goodwill, use, data or other intangible losses (even if The Company has been previously advised of such possibilities), resulting from your use of The Software and The Website or third-party libraries that are accessed through the system.\n\n\nB. Information Terms\n\na.The Company, The Software and The Website do not store information of any kind related to the User. Any GPS locations provided through the device services are solely used to detect a route to the destination selected and are not saved anywhere.\n\nb. You may not use The Software or The Website for any illegal or unauthorized purpose. You must not violate any laws in your location through the use of The Software and The Website (including but not limited to copyright or trademark laws).\n\n\nC. General Terms\n\na. The Company claims all intellectual property rights over the content provided in The Software and in The Website, this includes but is not limited to any maps and logos placed in The Software and The Website.\n\nb. The information provided on The Software and on The Website should not be relied upon as being error free or accurate and The Company is not to be held liable under any circumstances for any responsibility arising in any sort of way related to the use of The Software and The Website.\n\nc. Your use of The Software and The Website is at your sole risk. The Software and The Website are provided on an “AS IS” and “AS AVAILABLE” bases.\n\nd. You understand The Company makes use of third-party libraries, vendors and hosting partners in order to provide the necessary hardware, software, storage and related technologies to run The Software and The Website.\n\ne. You agree not to duplicate, copy, sell or exploit any portion of The Software and The Website without express written permission by The Company.\n\nf. You understand that the technical processing and transmission of data through The Software and The Website may not be encrypted and involve transmission over various networks.\n\ng. The Company does not warrant that The Software and The Website will:\ni. Meet any specific requirements;\nii. Will be uninterrupted, timely, secure or error-free;\niii. The results that may be obtained from the use of the service will be accurate or reliable;\niv. The quality of The Software or The Website will meet your expectations; and\nv. Any errors in The Software or The Website will be corrected.\n\nh. You expressly understand and agree that The Company shall not be liable for any direct, indirect, incidental, special, consequential or exemplary damages, including but not limited to, damages for loss of goodwill, use, data or other intangible losses (even if The Company had been previously advised of the possibilities), resulting from:\ni. The use or the inability to use The Software and The Website;\nii. Unauthorized access to or alteration of your transmissions or data;\niii. Statements or conduct of any third-party on The Software and The Website; and\niv. Any other matter relating to The Software and The Website.\n\n\ni. The failure of The Company to exercise or enforce any right or provision of the Terms of Service shall not constitute a waiver of such right or provision. The Terms of Service constitute the entirety of the agreement between You and The Company and govern Your use of The Software and The Website, superseding any prior agreements between You and The Company (including, but not limited to, any prior versions of the Terms of Service). You also agree that these Terms of Service and Your use of The Software and The Website are governed under the laws of the government of Australia."
    final private let privacyPolicyText = "A. General Information\n\na. If the location services (GPS features) are turned on for your device, we collect that information in order to provide you with a route to your destination. In the case it is turned off, we require you to select a location as your starting point and do not collect any data from the device.\n\n\nB. Data Storage\n\na. No data related to the user or the device is stored in our servers. The location data collected is used for the sole purpose of creating a route and is deleted afterwards.\n\nb. Central Institute of Technology uses third-party vendors and hosting partners to provide the necessary hardware, software, networking, storage and related technology required to run the Central Wayfinder software and the Website related to it.\n\n\nC. Changes\n\na. Central Institute of Technology may update this policy at anytime. Any changes will be displayed on the Website for the Central Wayfinder software and the latest version is going to be available on both the mobile application and the website related to it."
}