#!/bin/sh
#
# From
# https://stackoverflow.com/questions/5794640/how-to-convert-xcf-to-png-using-gimp-from-the-command-line
#
if [ ! -d xcf ]; then
    echo xcf2png requires xcf directory. Stop
    exit 1
fi
mkdir -p png
cd xcf
gimpx=`which gimp`
if [ "$gimpx" == "" ]; then
    macGimp=/Applications/gimp.app/contents/macos/gimp
    if [ -r $macGimp ]; then
	gimpx=$macGimp
    else
	echo $0: no gimp executable located. Stop.
	exit 1
    fi
fi
$gimpx -n -i -b - <<EOF
(let* ( (file's (cadr (file-glob "*.xcf" 1))) (filename "") (image 0) (layer 0) )
  (while (pair? file's) 
    (set! image (car (gimp-file-load RUN-NONINTERACTIVE (car file's) (car file's))))
    (set! layer (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
    (set! filename (string-append (substring (car file's) 0 (- (string-length (car file's)) 4)) ".png"))
    (gimp-file-save RUN-NONINTERACTIVE image layer filename filename)
    (gimp-image-delete image)
    (set! file's (cdr file's))
    )
  (gimp-quit 0)
  )
EOF
cd ..
mv xcf/*.png png
