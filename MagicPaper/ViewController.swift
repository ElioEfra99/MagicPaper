//
//  ViewController.swift
//  MagicPaper
//
//  Created by Eliu Efraín Díaz Bravo on 12/12/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: Bundle.main) {
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images successfully added")
        }
        
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let videoNode = SKVideoNode(fileNamed: "harry-potter.mp4")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            let imageDimension = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: imageDimension.width, height: imageDimension.height)
            
            plane.materials.first?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
             
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
        }
        
        return node
    }
}
