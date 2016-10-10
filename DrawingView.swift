
import Cocoa
import CoreGraphics
import Foundation


////////////////////////////////////////////
///////// Assign Element Structure /////////
////////////////////////////////////////////


enum TrapezoidPoint {
    
    case vertexOne(point: CGPoint)
    case vertexTwo(point: CGPoint)
    case vertexThree(point: CGPoint)
    case vertexFour(point: CGPoint)
    
    
    func pointCoordinates() -> [CGPoint] {
        
        switch self {
            
            case .vertexOne(let point): return [point]
            case .vertexTwo(let point): return [point]
            case .vertexThree(let point): return [point]
            case .vertexFour(let point): return [point]
        }
    }
    
    
    func pointColor() -> NSColor {
    
        switch self {
    
            case .vertexOne: return NSColor(calibratedRed: 1.0, green: 0, blue: 0, alpha: 0.75)
            case .vertexTwo: return NSColor(calibratedRed: 0.5, green: 0, blue: 0.25, alpha: 0.5)
            case .vertexThree: return NSColor(calibratedRed: 0.5, green: 0, blue: 0.25, alpha: 0.5)
            case .vertexFour: return NSColor(calibratedRed: 0.5, green: 0, blue: 0.25, alpha: 0.5)
        }
    }
    
    
    func segmentedQuadPath(path: CGMutablePath) {
    
        switch self {
            
            //nil is an UnsafePointer<CGAffineTransform>
            case .vertexOne(let point): CGPathMoveToPoint(path, nil, point.x, point.y)
            case .vertexTwo(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            case .vertexThree(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            case .vertexFour(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            CGPathCloseSubpath(path)
            
            NSColor.darkGrayColor().setStroke()
        }
    }
    
    
    func segmentedTriPath(path: CGMutablePath) {
        
        switch self {
            
            case .vertexOne(let point): CGPathMoveToPoint(path, nil, point.x, point.y)
            case .vertexTwo(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            case .vertexThree(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            //case .vertexFour(let point): CGPathAddLineToPoint(path, nil, point.x, point.y)
            default: ()
            CGPathCloseSubpath(path)
        
            NSColor.darkGrayColor().setStroke()
        }
        
    }
}



////////////////////////////////////////////
////////////// Second Part /////////////////
////////////////////////////////////////////


class DrawingView: NSView {
    
    @IBOutlet weak var trapezoid: NSButton!
    @IBOutlet weak var triangle: NSButton!

    
    ///////////////////////////////////////////
    ////// Use flipped coordinate system //////
    ///////////////////////////////////////////

    override internal var flipped: Bool {
        
        return true
    }
    deinit {
    }
    


    var totalArray: [TrapezoidPoint] = []
    private let vertexSize: CGFloat = 20.0
    private var trackingDot: TrapezoidPoint?
    private var trackingDotIndex: Int?
    private var trackingElementIndex: Int?
    
    
    
    private func circleBoxForVertices(point: CGPoint) -> CGRect {
        let circle = CGRect(x: point.x - vertexSize / 2,
                            y: point.y - vertexSize / 2,
                            width: vertexSize,
                            height: vertexSize)
        return circle
    }
   
    
    private func drawBoxAt(point: CGPoint, color: NSColor) {
        let rectangleBeTheCircle = circleBoxForVertices(point)
        
        GraphicsState {
            CGContextAddEllipseInRect(self.currentContext, rectangleBeTheCircle)
            color.setFill()
            
            //turning on "CGContextFillPath" for colorCoding vertices
            CGContextFillPath(self.currentContext)
        }
    }
    
    
    private func drawBackground() {
        let rectangleBG = bounds

        GraphicsState {
            CGContextAddRect(self.currentContext, rectangleBG)
            NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.5, alpha: 0).set()
            CGContextFillPath(self.currentContext)
        }
    }
    
    
    private func drawBorder() {
        let context = currentContext
        
        GraphicsState {
            NSColor.blackColor().set()
            CGContextStrokeRect(context, self.bounds)
        }
    }
    
    

    func appendDot(dot: TrapezoidPoint) {
        totalArray.append(dot)
        needsDisplay = true
    }
    
    
    
    
    func removeDot(dot: TrapezoidPoint) {
        if totalArray.capacity >= 1 {
            self.totalArray.popLast()
        }
        needsDisplay = true
    }
    

    
    
    ///////////////////////////////////////////
    ///////////// Build Quad Path /////////////
    ///////////////////////////////////////////

    
    func buildQuadPath() -> CGMutablePath {
        let path = CGPathCreateMutable()
        
        _ = totalArray.map { $0.segmentedQuadPath(path) }
        
        GraphicsState { self.setUpGState() }
        return path
    }
    
    

    func drawQuadPath() {
        let path = buildQuadPath()
        
        GraphicsState {
            CGContextAddPath(self.currentContext, path)
            CGContextStrokePath(self.currentContext)
        }
    }
  
    
    func drawQuadFill() {
        let fill = buildQuadPath()
        
        GraphicsState {
            CGContextAddPath(self.currentContext, fill)
            NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.75, alpha: 0.12).set()
            CGContextFillPath(self.currentContext)
        }
    }
    
    
    ///////////////////////////////////////////
    ////////////// Build Tri Path /////////////
    ///////////////////////////////////////////
    
    
    func buildTriPath() -> CGMutablePath {
        let path = CGPathCreateMutable()
        
        _ = totalArray.map { $0.segmentedTriPath(path) }
        GraphicsState { self.setUpGState() }
        
        return path
    }
    
    
    func drawTriPath() {
        let path = buildTriPath()
        
        GraphicsState {
            CGContextAddPath(self.currentContext, path)
            CGContextStrokePath(self.currentContext)
        }
    }
    
    
    func drawTriFill() {
        let fill = buildTriPath()
        
        GraphicsState {
            CGContextAddPath(self.currentContext, fill)
            NSColor(calibratedRed: 0.5, green: 0.5, blue: 0.75, alpha: 0.12).set()
            CGContextFillPath(self.currentContext)
        }
    }
    
    

    func drawPoints() {
        
        for dot in totalArray {
            
            for controlPoint in dot.pointCoordinates() {
                
                let color = dot.pointColor()
                drawBoxAt(controlPoint, color: color)
            }
        }
    }
 
 

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        drawBackground()
        GraphicsState { self.drawPoints() }
        
        if squareB >= 1 && triangleB == 0 {
            buildQuadPath()
            drawQuadPath()
            drawQuadFill()
            needsDisplay = true
            //setNeedsDisplayInRect(dirtyRect)

        }
        else if triangleB >= 1 && squareB == 0 {
            buildTriPath()
            drawTriPath()
            drawTriFill()
            needsDisplay = true
            //setNeedsDisplayInRect(dirtyRect)
        }
        drawBorder()
    }


    
    var squareB: Int = 0
    var triangleB: Int = 0
    

    
    ////////////////////////////////////////////
    //////////// Creating Trapezoid ////////////
    ////////////////////////////////////////////
    
    let variableTrapezoidOne = CGPoint(x: 100, y: 400)
    let variableTrapezoidTwo = CGPoint(x: 200, y: 400)
    let variableTrapezoidThree = CGPoint(x: 250, y: 500)
    let variableTrapezoidFour = CGPoint(x: 50, y: 500)
    
    //building a trapezoid (CCW)
    @IBAction func buildTrapezoid(sender: AnyObject?) {
        appendDot(.vertexOne(point: variableTrapezoidOne))
        appendDot(.vertexTwo(point: variableTrapezoidTwo))
        appendDot(.vertexThree(point: variableTrapezoidThree))
        appendDot(.vertexFour(point: variableTrapezoidFour))

        squareB += 1
        triangleB = 0
    }
    
    
    
    ////////////////////////////////////////////
    //////////// Creating Triangle /////////////
    ////////////////////////////////////////////
    
    let variableTriangleOne = CGPoint(x: 85, y: 600)
    let variableTriangleTwo = CGPoint(x: 215, y: 600)
    let variableTriangleThree = CGPoint(x: 150, y: 700)
    
    //building a triangle (CCW)
    @IBAction func buildTriangle(sender: AnyObject?) {
        appendDot(.vertexOne(point: variableTriangleOne))
        appendDot(.vertexTwo(point: variableTriangleTwo))
        appendDot(.vertexThree(point: variableTriangleThree))

        squareB = 0
        triangleB += 1
    }
    
    ////////////////////////////////////////////
    ///////////// Deletion Process /////////////
    ////////////////////////////////////////////
    
    let variableA = CGPointZero
    let variableB = CGPointZero
    let variableC = CGPointZero
    let variableD = CGPointZero
    
    //deleting a path
    @IBAction func automaticallyDeletePath(sender: AnyObject?) {
        removeDot(.vertexOne(point: variableA))
        removeDot(.vertexTwo(point: variableB))
        removeDot(.vertexThree(point: variableC))
        removeDot(.vertexFour(point: variableD))
    }
}
//the end of code