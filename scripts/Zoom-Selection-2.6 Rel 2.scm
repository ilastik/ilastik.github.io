; Zoom-Selection-2.6 Rel. 0.2 Created by graechan 
; Comments directed to https://gimpchat.com or https://gimpscripts.com
;
; License: GPLv3
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;    GNU General Public License for more details.
;
;    To view a copy of the GNU General Public License
;    visit: https://www.gnu.org/licenses/gpl.html
;
; ------------
;| Change Log |
; ------------ 
; Rel 0.01 - Initial Release
; Rel 0.02 - Added option to Zoom out on non selected area and improved error handling 
;;;;
(define (script-fu-zoom-selection-2.6 image drawable
                                        scale
										zoom-out
										shadow
										out-color
										radius
										texture
										image-tint-color
										image-tint-opacity
										zoom-tint-color
										zoom-tint-opacity
										zoom-tint-anim
							            conserve)
							  

 (let* (
            (image-layer (car (gimp-image-get-active-layer image)))
			(width (car (gimp-drawable-width image-layer)))
			(height (car (gimp-drawable-height image-layer)))
			(initial-layer 0)
			(zoom-layer 0)
			(init-width 0)
			(init-height 0)
			(drop-shadow-layer 0)
			(inner-shadow-layer 0)
			(brushName    "outlineBrush")
			(image-tint-layer 0)
			(texture-layer 0)
			(zoom-tint-layer 0)
			(selection-stroke-layer 0)
			(brush-size (* radius 2))
            (handler (car (gimp-message-get-handler)))			
        )
;;;;check that a selection was made
	(gimp-message-set-handler 0)
	(if (= (car (gimp-selection-is-empty image)) TRUE) (error "No Selection Found"))
	(gimp-message-set-handler handler)
	
	(gimp-context-push)
    (gimp-image-undo-group-start image)
	(gimp-context-set-foreground out-color)
	(gimp-context-set-background '(255 255 255))
	(gimp-layer-add-alpha image-layer)
	(gimp-drawable-set-name image-layer "Image")
		
;;;;create the initial-layer from selection	
	(if (= (car (gimp-selection-is-empty image)) FALSE)
	(begin
	(gimp-edit-copy image-layer)
	(gimp-edit-paste image-layer TRUE)
	(set! initial-layer (car (gimp-image-get-floating-sel image)))    
	(gimp-floating-sel-to-layer initial-layer)
	(gimp-drawable-set-name initial-layer "Initial Selection")
    (gimp-selection-none image) 
;;;;create the zoom-layer	
	(set! init-width (car (gimp-drawable-width initial-layer)))
    (set! init-height (car (gimp-drawable-height initial-layer)))
	(set! zoom-layer (car (gimp-layer-copy initial-layer TRUE)))
	(gimp-image-add-layer image zoom-layer -1)
	(gimp-drawable-set-name zoom-layer "Zoom")
    (gimp-selection-none image)
	
 (if (= zoom-out FALSE)
   (begin
;;;;resize the zoom-layer	
	(gimp-layer-scale-full zoom-layer (* init-width scale) (* init-height scale) TRUE INTERPOLATION-CUBIC)
	(gimp-image-resize-to-layers image)
   )
 )

 (if (= zoom-out TRUE)
   (begin	
;;;;resize the image layer
	(gimp-layer-scale-full image-layer (/ width scale) (/ height scale) TRUE INTERPOLATION-CUBIC)
	(gimp-image-resize-to-layers image)
   )
 )   
 
 (if (= shadow TRUE)
   (begin		
;;;;add a drop shadow
	(script-fu-drop-shadow image zoom-layer 8 8 15 out-color 50 FALSE)    	
		
;;;;add a inner shadow
	(set! inner-shadow-layer (car (gimp-layer-copy zoom-layer TRUE)))
	(gimp-image-add-layer image inner-shadow-layer -1)
	(gimp-drawable-set-name inner-shadow-layer "Inner Shadow")
	(gimp-selection-layer-alpha zoom-layer)
	(gimp-edit-clear inner-shadow-layer)
	(gimp-layer-resize-to-image-size inner-shadow-layer)
	
    ;; define new brush for drawing operation
            (gimp-brush-new brushName)
            (gimp-brush-set-shape brushName BRUSH-GENERATED-CIRCLE)    
            (gimp-brush-set-spikes brushName 2)
            (gimp-brush-set-hardness brushName 0.5)                   
            (gimp-brush-set-aspect-ratio brushName 1.0)
            (gimp-brush-set-angle brushName 0.0)                       
            (gimp-brush-set-spacing brushName 25.0)
            (gimp-brush-set-radius brushName 3)            
            (gimp-context-set-brush brushName)
            (gimp-context-set-foreground out-color)
            (gimp-edit-stroke inner-shadow-layer);;stroke the selection
            (gimp-brush-delete brushName)			
	(plug-in-gauss-rle2 RUN-NONINTERACTIVE image inner-shadow-layer 15 15) ;; shadow gaussien
    (gimp-layer-translate inner-shadow-layer 0 3);;inner-shadow-layer offset
    (gimp-selection-invert image);;invert selection
    (gimp-edit-clear inner-shadow-layer)	
   )
  )
 (if (= shadow FALSE) (gimp-selection-layer-alpha zoom-layer))
 (if (= shadow FALSE) (gimp-selection-invert image))	
	(gimp-layer-resize-to-image-size zoom-layer)
	(gimp-layer-resize-to-image-size initial-layer)
	(gimp-layer-resize-to-image-size image-layer)
	(set! width (car (gimp-image-width image)))
	(set! height (car (gimp-image-height image)))
;;;;create the outline and add stroke layer
 (if (= shadow FALSE)
   (begin
    (gimp-selection-invert image)
	(set! selection-stroke-layer (car (gimp-layer-new image width height RGBA-IMAGE "Selection Stroke" 100 NORMAL-MODE)))
    (gimp-image-add-layer image selection-stroke-layer -1)
	;; define new brush for drawing operation
            (gimp-brush-new brushName)
            (gimp-brush-set-shape brushName BRUSH-GENERATED-CIRCLE)    
            (gimp-brush-set-spikes brushName 2)
            (gimp-brush-set-hardness brushName 1.00)                   
            (gimp-brush-set-aspect-ratio brushName 1.0)
            (gimp-brush-set-angle brushName 0.0)                       
            (gimp-brush-set-spacing brushName 1.0)
            (gimp-brush-set-radius brushName brush-size)            
            (gimp-context-set-brush brushName)
            (gimp-context-set-foreground out-color)
			(gimp-edit-stroke selection-stroke-layer);;stroke the selection
            (gimp-brush-delete brushName)
			(gimp-edit-clear selection-stroke-layer)
			(gimp-selection-invert image)
   )
 )
	
;;;;add tint image layer and set to grain=merge with opacity control and color control	
    (gimp-image-set-active-layer image image-layer)
	(set! image-tint-layer (car (gimp-layer-new image width height RGBA-IMAGE "Image Tint" image-tint-opacity GRAIN-MERGE-MODE)))
    (gimp-image-add-layer image image-tint-layer -1)
	(gimp-context-set-foreground image-tint-color)
	(gimp-edit-fill image-tint-layer FOREGROUND-FILL)

;;;;add texture-layer
 (if (= texture TRUE)
   (begin
    (set! texture-layer (car (gimp-layer-new image width height RGBA-IMAGE "Texture" 50 NORMAL-MODE)))
    (gimp-image-add-layer image texture-layer -1)
    (plug-in-solid-noise RUN-NONINTERACTIVE image texture-layer 0 0 0 7 4 4)
    (plug-in-emboss RUN-NONINTERACTIVE image texture-layer 135 50 5 1)	
   )
 )
    ;(gimp-selection-none image)
  
	
;;;;add selection-tint-layer and set to grain-merge with opacity control
    (gimp-selection-invert image)
    (gimp-image-set-active-layer image zoom-layer)
    (set! zoom-tint-layer (car (gimp-layer-new image width height RGBA-IMAGE "Zoom Tint" zoom-tint-opacity MULTIPLY-MODE)))
    (gimp-image-add-layer image zoom-tint-layer -1)	
	(gimp-context-set-foreground zoom-tint-color)
	(gimp-edit-fill zoom-tint-layer FOREGROUND-FILL)
    (gimp-selection-none image)
	
;;;;create the animation image for the selection-tint-layer
 (if (= zoom-tint-anim TRUE)	
  (begin
    (gimp-drawable-set-visible zoom-tint-layer FALSE)
	(gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)
	(gimp-drawable-set-visible zoom-tint-layer TRUE)
	(script-fu-burn-in-anim image zoom-tint-layer '(255 255 255) FALSE 100 7 50 TRUE FALSE 50)
  )
 )

	
	(if (= conserve FALSE)	
        (begin	
	(set! zoom-layer (car (gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))
	(gimp-drawable-set-name zoom-layer "Zoom Selection")
	    )
    )
	
	)
	)
	
	
	
	
	
	
	
	
	
    
	(gimp-displays-flush)
	(gimp-image-undo-group-end image)
	(gimp-context-pop)
    



 )
) 



(script-fu-register "script-fu-zoom-selection-2.6"        		    
                    _"_Zoom Selection-2.6"
                     "Magnify part of a RGB or GRAYSCALE image from selection"
                    "Graechan"
                    "Graechan"
                    "January 2012"
                    "RGB* GRAY*"
                    SF-IMAGE      "image"      0
                    SF-DRAWABLE   "drawable"   0
                    SF-ADJUSTMENT "Zoom-Scale" '(1.5 1 3 .1 1 1 0)
					SF-TOGGLE     "Zoom-out the Background Instead"   FALSE
					SF-TOGGLE     "Shadow the Zoom layer"   FALSE
					SF-COLOR      "Shadow & Outline color"         '(0 0 0)
					SF-ADJUSTMENT "Outline Brush Size" '(1 0 100 .1 1 1 0)
					SF-TOGGLE     "Use Texture on Image"   FALSE
					SF-COLOR      "Image Tint Color" '(255 182 0)
					SF-ADJUSTMENT "Image Tint Opacity:set to 0 for no tint" '(0 0 100 1 10 0 0)
					SF-COLOR      "Zoom Tint Color" '(255 255 0)
					SF-ADJUSTMENT "Zoom Tint Opacity:set to 0 for no tint"  '(50 0 100 1 10 0 0)
					SF-TOGGLE     "Apply Zoom Tint as Animation"   FALSE
					SF-TOGGLE     "Keep the Layers"   FALSE
)

(script-fu-menu-register "script-fu-zoom-selection-2.6" "<Image>/Script-Fu/Effects Selection/")


