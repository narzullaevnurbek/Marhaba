//
//  Extentions.swift
//  Hotels
//
//  Created by Narzullaev Nurbek on 16/01/23.
//

import UIKit

typealias collD = UICollectionViewDelegate
typealias collDS = UICollectionViewDataSource
typealias collDFL = UICollectionViewDelegateFlowLayout
typealias imagePCD = UIImagePickerControllerDelegate
typealias navCD = UINavigationControllerDelegate

let buttonHeight: CGFloat = 49
let buttonTitleSize: CGFloat = 18
let buttonCornerRadius: CGFloat = 10
let gridSize: CGFloat = 15
let textFieldHeight: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 48 : 55
let userID = UIDevice.current.identifierForVendor!
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let screenWidth: CGFloat = UIScreen.main.bounds.size.width

let TFLeftMargin: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 18 : 20 // text field left margin size
let PRLeftMargin: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 11 : 15 // placeholder left margin size
let PRSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 17 : 17   // placeholder font size
let BTSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 17 : 18 // button title size
let BBSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 28 : 35 // back button size
let captionSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 16 : 16.5 // caption size in agreement label
let BVDevider: CGFloat = UIScreen.main.bounds.size.height < 812 ? 6.4 : 6 // bottom view (container) devider in auth page

let CIIcon = UIScreen.main.bounds.size.height <= 844 ? UIImage() : UIImage(named: "checkIn") // check in icon
let COIcon = UIScreen.main.bounds.size.height <= 844 ? UIImage() : UIImage(named: "checkOut") // check out icon
let CILMargin: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 30 : 50 // check in text field left margin
let SEGSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 290 : 290 // search engine group size
let LFSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 25 : 28 // label font size
let SAFSize: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 17 : 18 // see all font size

let NBWidth: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 330 : 350 // nearby layout group width
let RDIImageWidth: CGFloat = UIScreen.main.bounds.size.height <= 844 ? 80 : 100 // recommended layout item image width

func calculateDays(_ from: Date, and to: Date) -> Int {
    let calendar = Calendar.current
    let numberOfDays = calendar.dateComponents([.day], from: from, to: to)
    
    return numberOfDays.day!
}
