
import Cocoa
import CoreGraphics

extension NSView {

    var currentContext : CGContext? {
       
        get {
            
            let unsafeContextPointer = NSGraphicsContext.currentContext()?.graphicsPort
            
                if let contextPointer = unsafeContextPointer {
                let opaquePointer = COpaquePointer(contextPointer)
                let context: CGContextRef = Unmanaged.fromOpaque(opaquePointer).takeUnretainedValue()
                return context }
                else { return nil }
        }
    }
    
    func GraphicsState(drawStuff: () -> Void) {
        CGContextSaveGState(currentContext)
        drawStuff()
        CGContextRestoreGState(currentContext)
    }
}

//the end of code