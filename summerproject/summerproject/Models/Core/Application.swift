//
//  Application.swift
//  Check
//
//  Created by Zheng Hao Tan on 7/31/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

class Application: ApplicationProtocol {
    
    var backendService : ParseHandler?
    var isUsingParse: Bool
    
    var thisUser: Profile?
    
    init() {
        
        // Set up environment flags/variables.
        isUsingParse = true
        
        // Initialize current user profile.
        thisUser = Profile(username: "bean", password: "1234", email: "tandwao@umich.edu",
                            id: "12313", profilePicture: nil, name: "JOhn Doe",
                            biography: "toy", phoneNumber: "2015124444", checkPoints: 20,
                            isCheckVerified: true, reviewIds: nil, settings: nil)

        // Services for reviews, settings and the Parse handler.
        if (isUsingParse) {
            backendService = ParseHandler(thisUser: thisUser!)
        }
    }
    
    // MARK: Login/signup interface
    
    func signup() -> Bool {
        return backendService!.signUpParseProfile(thisUser!)
    }
    
    func isLoggedIn() -> Bool {
        return backendService!.isParseLoggedIn()
    }
    
    func login() -> Bool {
        return backendService!.loginParseProfile(thisUser!)
    }
    
    func logout() -> Bool {
        return backendService!.logoutParseProfile(thisUser!)
    }
    
    // MARK: Profile interface.
    
    func getProfile() -> Profile {
        
        if isUsingParse {
            return backendService!.getParseProfile()
        }
        
        return thisUser!
    }
    
    func removeProfile() {
        
        if isUsingParse {
            backendService!.removeParseProfile()
        }
    }
    
    func findAllProfilesInRegion(userLocation: Location) -> [Profile]? {

        return backendService!.findAllParseProfilesInRegion(userLocation)
    }
}