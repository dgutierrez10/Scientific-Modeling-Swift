//


// NSView display of second tab in Main.storyboard
import Cocoa
class DrawingView: NSView {
    
    
    /// Class Parameters Necessary for Drawing
    var counter: Int = 0 // counter of particles outside
    var percentage2: Double = 0.0
    var framewidth: CGFloat = 0.0
    var Energyloss: Double = 0.0
    var frameheight: CGFloat = 0.0
    var percentage: Double = 0.0
    var Nparticles: Int = 1
    var shouldIrandomwalk = false
    var shouldIrandomwalkNOlines = false
    var shouldImakewall = false
    var shouldIClear = true
    var shouldIDrawCircle = true
    var shouldIDrawPoints = false
    var shouldIDrawline = false
    var colorToDraw = "Blue"
    var allThePoints: [(xPoint: Double, yPoint: Double, radiusPoint: Double, color: String)] = []  ///Array of tuples
    var x: CGFloat = 20
    var y: CGFloat = 260
    var r: CGFloat = 1
    var angle: CGFloat = 0.0
    /// draw
    ///
    /// contains the drawing code for the points inside and outside of the circle
    /// - Parameter dirtyRect: Rectangle that will be drawn in
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        // draw a white box
        
        NSColor.white.setFill()
        bounds.fill()
        
        
        if shouldIClear {
            
            //draw a white box to clear
            //
            
            clear()
            shouldIClear = false
            
        }
        
        
       
        
        
       
        
        if shouldIDrawCircle {
            
            circle()
            
        }
        
        
        
        
        
        //        if shouldIDrawCircle {
        //
        //            circle()
        //
        //        }
        
        if shouldIDrawPoints {
            
            // Draw the points to the frame if needed
            
            for (_, item) in allThePoints.enumerated(){
                
                NSColor.red.setFill()
                
                if item.color == "Blue" {
                    
                    NSColor.blue.setFill()
                    
                }
                else if(item.color == "Red"){
                    
                    NSColor.red.setFill()
                    
                    
                }
                else if(item.color == "Green"){
                    
                    NSColor.green.setFill()
                    
                    
                }
                drawPoints(xPoint: item.xPoint, yPoint: item.yPoint, radiusPoint: item.radiusPoint)
                
                
                
                
            }
            
        }
        
        
    }
    
    /// clears the Display
    /// It Clears the display by drawing a white box
    func clear(){
        
        //allThePoints.removeAll()
        NSColor.white.setFill()
        bounds.fill()
        
        
    }
    
    
    
    
    
    /// draws a circle
    /// fills the entire frame with a circle
    func circle(){
        
        let circleFillColor = NSColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        
        let circleRect = NSMakeRect(self.frame.size.width/6, self.frame.size.height/6, self.frame.size.width/1.5, self.frame.size.height/1.5)
        let cPath: NSBezierPath = NSBezierPath(ovalIn: circleRect)
        circleFillColor.set()
        cPath.stroke()
        
        // 2/3 of circle
        // 1/6 and 1/1.5
        //
        //
        //1/2 of circle
        // 1/8*0 and 1/1
        //
        //
    }
    
    //circle
    
    
    
    
    
    /// draw the points
    ///
    /// - Parameters:
    ///   - xPoint: x component of the point to draw
    ///   - yPoint: y component of the point to draw
    ///   - radiusPoint: radius of the point but this is unneeded in this routine. Just for passing the tuple
    func drawPoints(xPoint: Double, yPoint: Double, radiusPoint: Double ){
        
        
        // Draw a rectangle of size 1 by 1 pixel at each point
        
        
        let aRect :NSRect = NSMakeRect(CGFloat(Float(xPoint)), CGFloat(Float(yPoint)), 4.0, 4.0)
        
        
        aRect.fill()
        
        
        
    }
    
    /// notifies the GUI that the display needs to be updated
    func tellGuiToDisplay(){
        
        needsDisplay = true
        
        
    }
    
    /// add points to the Array that will be drawn in the display
    ///
    /// - Parameters:
    ///   - xPointa: x component of the point to draw
    ///   - yPointb: y component of the point to draw
    ///   - radiusPointc: radius of the point to draw
    ///   - colord: color of the pixel (Blue if ouside of the circle, Red if inside the circle)
    func addPoint(xPointa: Double, yPointb: Double, radiusPointc: Double, colord: String){
        
        let arguments2 = (xPoint: xPointa, yPoint: yPointb, radiusPoint: radiusPointc, color: colord)
        
        allThePoints.append(arguments2)
        
    }
    
    func makewall(){
        
        makeline(distance: 240, showline: true)
        turn(angleChange: -90)
        makeline(distance: 240, showline: true)
        turn(angleChange: -90)
        makeline(distance: 240, showline: true)
        turn(angleChange: -90)
        makeline(distance: 240, showline: true)
        
        
    }
    
    
    
    
    
    
    // Erase after this
    let pi = CGFloat(Float.pi)
    
    func makeline(distance: Int, showline: Bool){
        
        
        let aPath = NSBezierPath()
        
        aPath.move(to: CGPoint(x: x, y: y))
        
        x = x + CGFloat(distance) * cos(angle * pi / 180)
        y = y + CGFloat(distance) * sin(angle * pi / 180)
        
        //r = sqrt(pow(x - self.frame.width / 2,2.0) + pow(y + self.frame.height / 2,2.0))
        
        r = sqrt(pow(x - self.frame.size.width / 2,2.0) + pow(y - self.frame.size.height / 2,2.0))
        
        aPath.line(to: CGPoint(x: x, y: y))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        
        aPath.close()
        
        if (showline == true){
            //If you want to stroke it with a red color
            NSColor.black.set()
            aPath.stroke()
            //If you want to fill it as well
            aPath.fill()
        }
        
    }
    
    func turn (angleChange: Int)
    {
        angle = angle + CGFloat(angleChange)
    }
    
    
    func randomwalkNeutron() -> Double{
        
        let framewidthi = self.frame.size.width
        var percentage3 = 0.0
        
        x = self.frame.size.width/2
        y = self.frame.size.height/2
        
        
        angle = CGFloat(Int.getRandomNumber(lower: 0, upper: 360))
        
        makeline(distance: Int(self.frame.size.width / 2.0), showline: true)
        
        var Energy: Int = 100
        Energy = Energy - (Int(Energyloss))
        
        counter = 0
        
        
        while(Energy > 0){
            
            
            
            let anglechange = Int.getRandomNumber(lower: 0, upper: 360)
            turn(angleChange: anglechange)
            makeline(distance: 28, showline: true)
            percentage = 0
            
            Energy = Energy - (Int(Energyloss))
            
            // if statement that stops when particles gets outside box
            
            
            
            if (Double(r) - Double(framewidthi) >= 0.0){
                
                Energy = 0
                percentage = 100
            }
            
        }
        percentage3 = percentage
        
        return percentage3
        
    }
    
    //For n particles  = 1
   
    
   
    
    //self.frame.size.width/8*0, self.frame.size.height/8*0, self.frame.size.width, self.frame.size.height
    //For the case of n particles > 1

    
    
}
