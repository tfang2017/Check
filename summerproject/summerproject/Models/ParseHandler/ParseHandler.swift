//
//  ParseHandler.swift
//  Check
//
//  Created by Zheng Hao Tan on 7/19/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation
import Parse

class ParseHandler: ParseHandlerProtocol {
    
    // MARK: Constants for the Parse profile keys
    private struct ParseProfileKeys {
        static let profilePicture = "profilePicture"
        static let name = "name"
        static let biography = "biography"
        static let phoneNumber = "phoneNumber"
        static let checkPoints = "checkPoints"
        static let isCheckVerified = "isCheckVerified"
        static let reviewIds = "reviewIds"
        static let settings = "settings"
    }
    
    private struct ParseReviewKeys {
        static let className = "Review"
        static let reviewId = "reviewId"
        static let timeCreated = "timeCreated"
        static let lastUpdated = "lastUpdated"
        static let reviewer = "reviewer"
        static let description = "description"
    }
    
    var thisUser: Profile
    var facebookProfile : FacebookProfile?
    
    // MARK: Constructor
    init(thisUser: Profile) {
        self.thisUser = thisUser
        self.facebookProfile = FacebookProfile()
    }

    func loginParseProfile(userProfile: Profile) -> Bool {
        
        var isSuccessfulLogin : Bool = false
        
        PFUser.logInWithUsernameInBackground(userProfile.username, password: userProfile.password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                isSuccessfulLogin = true
                println("Parse user login success.")
            } else {
                // The login failed. Check error to see why.
                isSuccessfulLogin = false
                println("Parse user login failed.")
            }
        }
        return isSuccessfulLogin
    }
    
    func logoutParseProfile(userProfile: Profile) -> Bool {
        PFUser.logOut()
        return true
    }
    
    func signUpParseProfile(userProfile: Profile) -> Bool {
        
        let userParseProfile = PFUser()
        
        // Populate and add all user data into the Parse Profile.
        userParseProfile.username = userProfile.username
        userParseProfile.password = userProfile.password
        userParseProfile.email = userProfile.email
        
        // Handle profile picture.
        let imageData = UIImagePNGRepresentation(userProfile.profilePicture)
        let imageFile = PFFile(name:"profilePic.png", data:imageData)
        userParseProfile[ParseProfileKeys.profilePicture] = imageFile
        
        userParseProfile[ParseProfileKeys.name] = userProfile.name
        userParseProfile[ParseProfileKeys.biography] = userProfile.biography
        userParseProfile[ParseProfileKeys.phoneNumber] = userProfile.phoneNumber
        userParseProfile[ParseProfileKeys.checkPoints] = userProfile.checkPoints
        userParseProfile[ParseProfileKeys.isCheckVerified] = userProfile.isCheckVerified
        userParseProfile[ParseProfileKeys.reviewIds] = userProfile.reviewIds
        userParseProfile[ParseProfileKeys.settings] = userProfile.settings
        
        userParseProfile.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Parse user profile signed up successfully.")
        }
        
        userProfile.id = userParseProfile.objectId
        
        return true
    }

    
    func removeParseProfile() {
        
        // error check - Parse profile does not exist.
        
        // TODO: Implement remove parse profile.
    }
    
    func getParseProfile() -> Profile {
        
        var userProfile : Profile?
        var userParseProfile = PFUser.currentUser()
        
        if userParseProfile != nil {
                
            userProfile!.profilePicture = (userParseProfile?.objectForKey("profilePicture") as? UIImage)!
            userProfile!.name = (userParseProfile?.objectForKey("name") as? String)!
            userProfile!.biography = (userParseProfile?.objectForKey("biography") as? String)!
            userProfile!.phoneNumber = (userParseProfile?.objectForKey("phoneNumber") as? String)!
            userProfile!.checkPoints = (userParseProfile?.objectForKey("checkPoints") as? Int)!
            userProfile!.isCheckVerified = (userParseProfile?.objectForKey("isCheckVerified") as? Bool)!
            userProfile!.reviewIds = (userParseProfile?.objectForKey("reviews") as? [String]?)!
            userProfile!.settings = (userParseProfile?.objectForKey("settings") as? Settings)!
        }
        else {
            println("Error occured while fetching ParseProfile")
        }

        return userProfile!
    }

    func isParseLoggedIn() -> Bool {
        return PFUser.currentUser() != nil
    }
    
    
    // MARK: Facebook interface in Parse
    
    
    func loginParseFacebookProfile(userProfile: Profile) -> Bool {
        
        return facebookProfile!.loginWithReadPermissions()
    }

    func linkParseProfileToFacebook(userProfile: Profile) -> Bool {
        
        var isSuccessfulLinking = false
        var user = PFUser.currentUser()
        // TODO:
//        if !PFFacebookUtils.isLinkedWithUser(user!) {
//            PFFacebookUtils.linkUserInBackground(user!, withReadPermissions: nil, block: {
//                (succeeded: Bool?, error: NSError?) -> Void in
//                if (succeeded != nil) {
//                    println("The user is linked with Facebook!")
//                    isSuccessfulLinking = true
//                }
//            })
//        }
        
        return isSuccessfulLinking
    }
    
    func unlinkParseProfileToFacebook(userProfile: Profile) -> Bool {
        
        var isSuccessfulUnlinking = false
        var currentUser = PFUser.currentUser()
        // TODO: 
//        PFFacebookUtils.unlinkUserInBackground(currentUser!, block: {
//            (succeeded: Bool?, error: NSError?) -> Void in
//            if (succeeded != nil) {
//                println("The user is no longer associated with their Facebook account.")
//                isSuccessfulUnlinking = true
//            }
//        })
        
        return isSuccessfulUnlinking
    }
    
    func findAllParseProfilesInRegion(userLocation: Location) -> [Profile]? {
        return facebookProfile!.findAllFacebookProfilesInRegion(userLocation)
    }
    
    // MARK: Username interface in Parse
    
    // REQUIRES: A user profile and a new password.
    // EFFECTS: Changes the user's username in Parse.
    func changeParseUsername(newUsername: String) {
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        thisUser.username = newUsername
        userParseProfile!.username = newUsername
        userParseProfile!.save()
    }
    
    
    // MARK: Password interface in Parse
    
    func resetParsePassword(userProfile: Profile) {
        PFUser.requestPasswordResetForEmailInBackground(userProfile.email)
    }
    
    // REQUIRES: A user profile and a new password.
    // EFFECTS: Changes the user's password in Parse.
    func changeParsePassword(newPassword: String) {
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        thisUser.password = newPassword
        userParseProfile!.password = newPassword
        userParseProfile!.save()
    }
    
    
    // MARK: Email interface in Parse
    
    
    // REQUIRES: A user profile and a new email address.
    // EFFECTS: Changes the user's email in Parse.
    func changeParseEmail(newEmail: String) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile!.email = newEmail
        userParseProfile!.save()
    }
    
    
    // MARK: Profile picture interface in Parse
    
    
    func changeProfilePicture(newProfilePic: UIImage) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        // Convert UIImage to a PNG file, and then into PFFile.
        let imageData = UIImagePNGRepresentation(newProfilePic)
        let imageFile = PFFile(name:"profilePic.png", data:imageData)
        
        userParseProfile![ParseProfileKeys.profilePicture] = imageFile
        userParseProfile!.saveInBackground()
    }
    
    // MARK: Name interface in Parse
    
    
    // REQUIRES: A user profile and a new name.
    // EFFECTS: Changes the user's name in Parse.
    func changeParseName(newName: String) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.name] = newName
        userParseProfile!.saveInBackground()
    }
    
    
    // MARK: Biography interface in Parse.
    
    // REQUIRES: A user profile and a new biography.
    // EFFECTS: Changes the user's biography in Parse.
    func changeParseBiography(newBiography:String) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.biography] = newBiography
        userParseProfile!.saveInBackground()
    }
    
    // MARK: Phone number interface in Parse.
    
    // REQUIRES: A user profile and a new phone number.
    // EFFECTS: Changes the user's phone number.
    func changeParsePhoneNumber(newPhoneNumber: String) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.phoneNumber] = newPhoneNumber
        userParseProfile!.saveInBackground()
    }
    
    
    // MARK: Checkpoints interface in Parse.
    
    
    // REQUIRES: A user profile and check point value.
    // EFFECTS: Increments the check points on the particular user.
    func addParseCheckPoints(checkPointsValue: Int) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.checkPoints] = userParseProfile![ParseProfileKeys.checkPoints] as! Int + checkPointsValue
        userParseProfile!.saveInBackground()
    }
    
    
    // REQUIRES: A user profile and check point value.
    // EFFECTS: Decrements the check points on the particular user.
    func subtractParseCheckPoints(checkPointsValue: Int) {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.checkPoints] = userParseProfile![ParseProfileKeys.checkPoints] as! Int - checkPointsValue
        userParseProfile!.saveInBackground()
    }
    
    
    // MARK: IsCheckVerified interface in Parse.
    
    
    // REQUIRES: A user profile.
    // EFFECTS: Sets the user to be check verified.
    func addParseCheckVerified() {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.isCheckVerified] = true
        userParseProfile!.saveInBackground()
    }
    
    // REQUIRES: A user profile.
    // EFFECTS: Removes check verified status from the user.
    func removeParseCheckVerified() {
        
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(thisUser)
        }
        
        userParseProfile![ParseProfileKeys.isCheckVerified] = false
        userParseProfile!.saveInBackground()
    }
    
    
    // MARK: Reviews stored in Parse.
    
    func addParseReview(userProfile: Profile, userReview: Review) {
        var userParseProfile = PFUser.currentUser()
        
        if (userParseProfile == nil) {
            loginParseProfile(userProfile)
        }
        
        // TODO: Query for user and then add this review.
        userParseProfile![ParseProfileKeys.reviewIds] = userProfile.reviewIds
        userParseProfile!.saveInBackground()
    }
    
    func removeParseReview(reviewId: String) {
        
        // Search for ParseObjectid and delete it.
        var query = PFQuery(className:ParseReviewKeys.className)
        
        query.getObjectInBackgroundWithId(reviewId) {
            (review: PFObject?, error: NSError?) -> Void in
            if error == nil && review != nil {
                review!.deleteInBackground()
                println("Review successfully deleted!")
            } else {
                println(error)
            }
        }
    }
    
    func updateParseReview(reviewId: String, userReview: Review) {

        var query = PFQuery(className:ParseReviewKeys.className)
        
        query.getObjectInBackgroundWithId(reviewId) {
            (review: PFObject?, error: NSError?) -> Void in

            if error != nil {
                println(error)
            }
            else if let review = review {
                
                review[ParseReviewKeys.description] = userReview.description
                // Update and save.
                review[ParseReviewKeys.lastUpdated] = NSDate();
                review.saveInBackground()
                println("Review successfully updated!")
            }
            else {
                println(error);
            }
        }
    }
    
    func getParseReviews(reviewIds :[String]?) -> [Review]? {
        
        var reviews : [Review]? = nil
        
        if let tempReviews = reviewIds {
            for reviewId in tempReviews {
                
                var query = PFQuery(className:ParseReviewKeys.className)
                query.getObjectInBackgroundWithId(reviewId) {
                    (review: PFObject?, error: NSError?) -> Void in
                    
                    if error == nil && review != nil {
                        
                        // Fetch all the data
                        let timeCreated = review?.objectForKey(ParseReviewKeys.timeCreated) as? NSDate
                        let lastUpdated = review?.objectForKey(ParseReviewKeys.lastUpdated) as? NSDate
                        let reviewId = review?.objectForKey(ParseReviewKeys.reviewId) as? String
                        let reviewer = review?.objectForKey(ParseReviewKeys.reviewer) as? Profile
                        let description = review?.objectForKey(ParseReviewKeys.description) as? String
                        
                        // Append into lists of reviews.
                        if timeCreated != nil && lastUpdated != nil && reviewId != nil && reviewer != nil && description != nil {
                            let tempReview = Review(timeCreated: timeCreated!, lastUpdated: lastUpdated!, reviewId: reviewId!, reviewer: reviewer!, description: description!)
                            
                            reviews?.append(tempReview)
                        }

                    } else {
                        println("Failed to get Parse reviews")
                        println(error)
                    }
                }
            }
        }

        return reviews
    }
    
    // Settings stored in Parse.
    func addParseSettings(userSettings: Settings) {
        
    }
    
    func updateParseSettings(userSettings: Settings) {
        
    }
}