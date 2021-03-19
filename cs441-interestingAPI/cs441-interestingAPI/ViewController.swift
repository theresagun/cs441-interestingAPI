//
//  ViewController.swift
//  cs441-interestingAPI
//
//  Created by Theresa Gundel on 3/15/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arView.session.delegate = self //so we can call the did add anchors

        setUpARView()

        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }

    //for set up
    func setUpARView(){
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration() //there are world, image, and face tracking configs
        config.planeDetection = [.horizontal, .vertical] // array of values to set
        config.environmentTexturing = .automatic //makes objs placed look as realisitic as possible
        arView.session.run(config)

    }

    //for obj placement
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        //when someone taps it calls this function
        let location = recognizer.location(in: arView)

        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            //if we actually found a horizontal surface
            //to place an obj to scene, must be anchored
            //name of anchor is the name of the asset
            let anchor = ARAnchor(name: "ContemporaryFan", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        }else{
            print("No horizontal surface found - could not place obj")
        }
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor){
        //all objs from scene are entities (model entities in this case
        let entity = try! ModelEntity.loadModel(named: entityName) //create model entity
        
        entity.generateCollisionShapes(recursive: true) //allows us to drag and rotate to scene
        arView.installGestures([.rotation, .translation], for: entity)
        
        let anchorEntity = AnchorEntity(anchor: anchor) //create anchor entity
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity) // add to scene
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        // Load the "Box" scene from the "Experience" Reality File
////        let boxAnchor = try! Experience.loadBox()
////
////        // Add the box anchor to the scene
////        arView.scene.anchors.append(boxAnchor)
//
//        // Load the "Box" scene from the "Experience" Reality File
//        let test = testBox.init()
//
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(test)
//    }
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == "contemporaryFan"{
                //place obj with name for specific anchor
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
