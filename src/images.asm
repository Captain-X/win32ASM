include stdafx.inc

public hBitmapBG
public hBitmapBG1
public hBitmapBG2
public hBitmapBG3
public hBitmapLeaf
public hBitmapFrog

.data?
hBitmapBG dd ?
hBitmapBG1 dd ?
hBitmapBG2 dd ?
hBitmapBG3 dd ?
hBitmapLeaf dd ?
hBitmapFrog dd ?

.const
bgimg db 'images\\0.bmp', 0
startimg db 'images\\1.bmp', 0
endimg db 'images\\2.bmp', 0
leaf db 'images\\leaf.bmp', 0
frog db 'images\\ha1.bmp', 0

.code
ImagesInit proc
    invoke LoadImage, NULL, addr bgimg, IMAGE_BITMAP, 800, 670, LR_LOADFROMFILE
    mov hBitmapBG1, eax
    mov hBitmapBG, eax
    invoke LoadImage, NULL, addr startimg, IMAGE_BITMAP, 800, 670, LR_LOADFROMFILE
    mov hBitmapBG2, eax
    invoke LoadImage, NULL, addr endimg, IMAGE_BITMAP, 800, 670, LR_LOADFROMFILE
    mov hBitmapBG3, eax
    invoke LoadImage, NULL, addr leaf, IMAGE_BITMAP, 156, 67, LR_LOADFROMFILE
    mov hBitmapLeaf, eax
    invoke LoadImage, NULL, addr frog, IMAGE_BITMAP, 75, 55, LR_LOADFROMFILE
    mov hBitmapFrog, eax
    ret
ImagesInit endp
end