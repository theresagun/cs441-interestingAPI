//
//  testBox.swift
//  cs441-interestingAPI
//
//  Created by Theresa Gundel on 3/19/21.
//

import UIKit
import RealityKit

class testBox: Entity, HasModel, HasCollision, HasAnchoring { //must inherit from Entity to show up on the scene
    //HasModel is a protocol, other useful ones: HasAnchoring, HasCollision (allows it to be tappable)
  required init() {
    super.init()
    self.components[ModelComponent] = ModelComponent(
      mesh: .generateBox(size: [1, 0.2, 1]),
      materials: [SimpleMaterial(
                    color: UIColor.purple,
        isMetallic: false)
      ]
    )
    self.generateCollisionShapes(recursive: true)
  }
    
}
