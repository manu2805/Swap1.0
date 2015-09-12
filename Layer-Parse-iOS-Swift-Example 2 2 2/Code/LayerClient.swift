//
//  LayerClient.swift
//  Layer-Parse-iOS-Swift-Example
//
//  Created by Manudeep N.s on 7/24/15.
//  Copyright (c) 2015 layer. All rights reserved.
//

import Foundation

class LayerClient {
    let LayerAppIDString: NSURL! = NSURL(string: "layer:///apps/production/7efd3444-2e82-11e5-a212-42906a01766d")
    var layerClient: LYRClient!
    
    //TESTING FOR STRING SEARCH! IF THIS WORKS MAKE A NEW CLASS
    var searchString: String?
    
    init() {
        self.layerClient = LYRClient(appID: LayerAppIDString)
        layerClient.autodownloadMaximumContentSize = 1024 * 100
        layerClient.autodownloadMIMETypes = NSSet(object: "image/jpeg") as Set<NSObject>
    }
    
}

var mainLayerClient = LayerClient()