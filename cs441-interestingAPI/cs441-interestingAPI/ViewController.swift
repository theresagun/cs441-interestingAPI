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
    
    @IBOutlet var showPlants: UIButton!
    @IBOutlet var showButterflies: UIButton!
    @IBOutlet var p1: UIButton!
    @IBOutlet var p2: UIButton!
    @IBOutlet var p3: UIButton!
    
    var isPlants: Bool!
    var image3d: String!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arView.session.delegate = self //so we can call the did add anchors

        setUpARView()

        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        //p1.buttonType = UIButton.ButtonType(0)
        p1.setImage(UIImage(named: "flower1.png"), for: .normal)
        p2.setImage(UIImage(named: "flower2.png"), for: .normal)
        p3.setImage(UIImage(named: "flower3.png"), for: .normal)
        image3d = "flower1"
        isPlants = true
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
            let anchor = ARAnchor(name: image3d, transform: firstResult.worldTransform)
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
    
    @IBAction func clickedPlants(){
        p1.setImage(UIImage(named: "flower1.png"), for: .normal)
        p2.setImage(UIImage(named: "flower2.png"), for: .normal)
        p3.setImage(UIImage(named: "flower3.png"), for: .normal)
        isPlants = true
    }
    
    @IBAction func clickedButterflies(){
        p1.setImage(UIImage(named: "butterfly1.png"), for: .normal)
        p2.setImage(UIImage(named: "butterfly2.png"), for: .normal)
        p3.setImage(UIImage(named: "butterfly3.png"), for: .normal)
        isPlants = false
    }
    
    @IBAction func clickedP1(){
        NSLog("Clicked p1")
        if isPlants{
            image3d = "flower1edit"
        }
        else{
            image3d = "butterfly1edit"
        }
    }
    
    @IBAction func clickedP2(){
        NSLog("Clicked p2")
        if isPlants{
            image3d = "flower2"
        }
        else{
            image3d = "butterfly2edit"
        }
    }
    
    @IBAction func clickedP3(){
        NSLog("Clicked p3")
        if isPlants{
            image3d = "flower3"
        }
        else{
            image3d = "butterfly3edit"
        }
    }
    
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors{
            if let anchorName = anchor.name, anchorName == image3d{
                //place obj with name for specific anchor
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
