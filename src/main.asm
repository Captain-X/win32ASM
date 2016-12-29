include stdafx.inc
include images.inc

mRepeat macro dPosX
  mov eax, dPosX
  add eax,156
  sub edx,edx
  div mov_width
  sub edx,156
  mov dPosX, edx
endm

maddText macro textName, dPosX, dPosY
  mov eax, dPosX
  mov ebx, dPosY
  add eax, 25
  mov @stRectWord.left, eax
  add ebx, 30
  mov @stRectWord.top, ebx
  add ebx, 18
  mov @stRectWord.bottom, ebx
  add eax, 105
  mov @stRectWord.right, eax
  invoke DrawText, @hDc, textName, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER
endm

mAddFrog macro dPosX, dPosY
  mov eax, dPosX
  add eax, 35
  mov @dPosFrog, eax
  mov ebx, dPosY
  sub ebx, 25
  invoke CreateCompatibleDC, @hDc
  mov @hDcFrog, eax ; Frog DC
  invoke SelectObject, @hDcFrog, hBitmapFrog
  invoke TransparentBlt, @hDc, @dPosFrog, ebx, 75, 55, @hDcFrog, 0, 0, 75, 55, 0ffffffh
endm

Leaf struct
  x dd ?
  y dd ?
  wordIndex dd ?
Leaf ends

.data
leaf1 Leaf {-80, 415, 0}
leaf2 Leaf {-80, 325, 1}
leaf3 Leaf {-80, 235, 2}

matched dd 0

word1 db 'young', 0
word2 db 'simple', 0
word3 db 'sometimes', 0
word4 db 'naive', 0


word11 db 'extrn', 0
word21 db 'public', 0
word31 db 'mov', 0
word41 db 'add', 0
word12 db 'int', 0
word22 db 'out', 0
word32 db 'offset', 0
word42 db 'jmp', 0
word13 db 'cmp', 0
word23 db 'jnz', 0
word33 db 'rep', 0
word43 db 'rol', 0

time dd  0
timeStr  db  '00:00:00',0
levelStr  db  'level:1',0
sec  dd 0
min  dd 0
hour dd 0
status dd 0
speed dd 4
level dd 1
mov_width dd 810+156
.data?
hInstance dd  ?
hWinMain dd  ?
hBitmapHero dd ?

hIcon dd ?
hMenu dd ?

;word1 dd ?
;word2 dd ?
;word3 dd ?
;word4 dd ?

.const
num10 dd 10
num60 dd 60
num3600 dd 3600
szIcon db 'images\\icon.ico', 0
szBitmapTile db 'images\\tile.bmp', 0
szBitmapHero db 'images\\hero.bmp', 0
bgm db 'images\\BG.wav',0

szClassName db 'MainWindow', 0
szMenuNewGame db '新游戏(&N)', 0
szMenuQuit db '退出(&Q)', 0
szCaptionMain db '激流勇进', 0
szHeroHealth db '生命', 0
szHeroAttack db '攻击力', 0
szText db 'sometimes naive', 0

.code
invoke PlaySound, addr bgm, NULL, SND_FILENAME or SND_ASYNC


ProcTimer proc hWnd, uMsg, idEvent, dwTime
  local @stRect: RECT
  .if status != 0
  .if status !=5
    inc time  
  .endif

  sub edx, edx
  mov eax, time
  div num10
  sub edx, edx
  div num3600
  mov hour, eax
  mov eax, edx
  sub edx, edx
  div num60
  mov min, eax
  mov sec, edx
  ;PrintHex hour
  ;PrintHex min
  ;PrintHex sec

  sub edx, edx
  mov eax, hour
  div num10
  add eax, 30H
  add edx, 30H
  mov timeStr[0], al
  mov timeStr[1], dl

  sub edx, edx
  mov eax, min
  div num10
  add eax, 30H
  add edx, 30H
  mov timeStr[3], al
  mov timeStr[4], dl

  sub edx, edx
  mov eax, sec
  div num10
  add eax, 30H
  add edx, 30H
  mov timeStr[6], al
  mov timeStr[7], dl

  mov eax, leaf1.x
  mov ebx, leaf1.y
  mov @stRect.left, eax
  add eax, 160
  mov @stRect.right, eax
  sub ebx, 25
  mov @stRect.top, ebx
  add ebx, 92
  mov @stRect.bottom, ebx
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd

  mov eax, leaf2.x
  mov ebx, leaf2.y
  mov @stRect.left, eax
  add eax, 150
  mov @stRect.right, eax
  sub ebx, 25
  mov @stRect.top, ebx
  add ebx, 92
  mov @stRect.bottom, ebx
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd

  mov eax, leaf3.x
  mov ebx, leaf3.y
  mov @stRect.left, eax
  add eax, 150
  mov @stRect.right, eax
  sub ebx, 25
  mov @stRect.top, ebx
  add ebx, 92
  mov @stRect.bottom, ebx
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd



  mov edx, speed
  add leaf1.x,edx
  inc edx
  add leaf2.x,edx
  inc edx
  add leaf3.x,edx

  push leaf1.x
  mRepeat leaf1.x
  pop ecx
  .if ecx < leaf1.x && status==2
    sub status,1
    invoke GetClientRect, hWnd, addr @stRect
    invoke InvalidateRect, hWnd, addr @stRect, TRUE
    invoke UpdateWindow, hWnd
 ;   lea edx, word11
 ;   mov word1, edx
  .endif

  push leaf2.x
  mRepeat leaf2.x
  pop ecx
  .if ecx < leaf2.x && status==3
    sub status,1
  .endif

  push leaf3.x
  mRepeat leaf3.x
  pop ecx
  .if ecx < leaf3.x && status==4
    sub status,1
  .endif
.endif


ProcTimer endp


ProcChar proc hWnd, uMsg, wParam, lParam
    local @stRect: RECT

    .if status == 1
      lea ebx, word1
      mov edx, lengthof word1
      dec edx
    .elseif status == 2
      lea ebx, word2
      mov edx, lengthof word2
      dec edx
    .elseif status == 3
      lea ebx, word3
      mov edx, lengthof word3
      dec edx
    .elseif status == 4
      lea ebx, word4
      mov edx, lengthof word4
      dec edx
    .else
      ret
    .endif

    mov ecx, matched
    mov eax, 0
    mov al, [ebx + ecx]
    .if eax == wParam
      ;PrintHex eax
      ;PrintHex wParam
      ;PrintHex edx
      inc ecx
      .if ecx == edx 
        inc status
        invoke GetClientRect, hWnd, addr @stRect
        invoke InvalidateRect, hWnd, addr @stRect, TRUE
        invoke UpdateWindow, hWnd
      .endif
      mov matched, ecx
    .endif
    invoke GetClientRect, hWnd, addr @stRect
    invoke InvalidateRect, hWnd, addr @stRect, TRUE
    invoke UpdateWindow, hWnd

   .if wParam == 032H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,2
      invoke GetClientRect, hWnd, addr @stRect
      invoke InvalidateRect, hWnd, addr @stRect, TRUE
      invoke UpdateWindow, hWnd
   .endif

   .if wParam == 033H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,3
   .endif

   .if wParam == 034H
      mov eax, hBitmapBG1
      mov hBitmapBG, eax
      mov status,4
   .endif

   .if wParam == 035H
    mov eax, hBitmapBG3
    mov hBitmapBG, eax
    mov status,5
  .endif

   ret
ProcChar endp

ProcKeydown proc hWnd, uMsg, wParam, lParam
  local @stRect: RECT
  .if wParam >= 041H && wParam <= 05AH

  .endif

;.if wParam == VK_RETURN && (status==0 || status==5)
;    mov eax, hBitmapBG2
;    mov hBitmapBG, eax
;    .if status==5
;     mov time,0
;   .endif 
;   mov status,1
; .endif

.if wParam == VK_RETURN && status==0
   mov eax, hBitmapBG2
   mov hBitmapBG, eax
   mov status,1   
 .endif

.if wParam == VK_RETURN && status==5
   mov eax, hBitmapBG2
   mov hBitmapBG, eax
   mov time,0
   mov status,1
   add speed,2
   inc levelStr[6]   
 .endif

  .if wParam == VK_DELETE
    mov eax, hBitmapBG1
    mov hBitmapBG, eax
    mov status,2
  .endif

  .if wParam == VK_INSERT
    mov eax, hBitmapBG3
    mov hBitmapBG, eax
    mov status,1
  .endif

  invoke GetClientRect, hWnd, addr @stRect
  invoke InvalidateRect, hWnd, addr @stRect, TRUE
  invoke UpdateWindow, hWnd
  ret
ProcKeydown endp

_ProcWinMain proc uses ebx edi esi hWnd, uMsg, wParam, lParam
  local @stPs: PAINTSTRUCT
  local @stRect: RECT
  local @stRectWord:RECT
  local @hDc
  local @hBMP
  local @hDcBG
  local @hDcLeaf
  local @hDcLeaf2
  local @hDcLeaf3
  local @hDcFrog
  local @dPosFrog

  mov eax, uMsg
  ; PrintHex eax
  .if eax == WM_PAINT
    invoke BeginPaint, hWnd, addr @stPs
    mov @hDc, eax
    
    invoke CreateCompatibleDC, @hDc
    mov @hDcBG, eax ; Background DC
    invoke SelectObject, @hDcBG, hBitmapBG
    invoke BitBlt, @hDc, 0, 0, 800, 670, @hDcBG, 0, 0, SRCCOPY
    invoke DeleteDC, @hDcBG
    mov eax, hBitmapBG

    mov eax, 680
    mov ebx, 90
    add eax, 25
    mov @stRectWord.left, eax
    add ebx, 33
    mov @stRectWord.top, ebx
    add ebx, 10
    mov @stRectWord.bottom, ebx
    add eax, 105
    mov @stRectWord.right, eax
    invoke DrawText, @hDc, addr timeStr, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER

    mov eax, 610
    mov ebx, 90
    add eax, 25
    mov @stRectWord.left, eax
    add ebx, 33
    mov @stRectWord.top, ebx
    add ebx, 10
    mov @stRectWord.bottom, ebx
    add eax, 105
    mov @stRectWord.right, eax
    invoke DrawText, @hDc, addr levelStr, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER
    
    
    .if status == 1
      ;add leaf
      mov eax, hBitmapBG2
      mov hBitmapBG, eax

      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, leaf1.x, leaf1.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf2.x, leaf2.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf3.x, leaf3.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh


      maddText  addr word1, leaf1.x, leaf1.y
      maddText  addr word2, leaf2.x, leaf2.y
      maddText  addr word3, leaf3.x, leaf3.y

      mov @stRectWord.left, 450
      mov @stRectWord.top, 133
      mov @stRectWord.bottom, 150
      mov @stRectWord.right, 555
      invoke DrawText, @hDc, addr word4, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER


      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif


    .if status == 2
      ;add leaf
      mov eax, hBitmapBG1
      mov hBitmapBG, eax

      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, leaf1.x, leaf1.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf2.x, leaf2.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf3.x, leaf3.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      maddText addr word1, leaf1.x, leaf1.y
      maddText addr word2, leaf2.x, leaf2.y
      maddText addr word3, leaf3.x, leaf3.y

      mov @stRectWord.left, 450
      mov @stRectWord.top, 133
      mov @stRectWord.bottom, 150
      mov @stRectWord.right, 555
      invoke DrawText, @hDc, addr word4, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER    

      mAddFrog leaf1.x, leaf1.y

      invoke DeleteDC, @hDcLeaf

      invoke DeleteDC, @hDcFrog
    .endif

    .if status == 3
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, leaf1.x, leaf1.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf2.x, leaf2.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf3.x, leaf3.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      maddText addr word1, leaf1.x, leaf1.y
      maddText addr word2, leaf2.x, leaf2.y
      maddText addr word3, leaf3.x, leaf3.y

      mov @stRectWord.left, 450
      mov @stRectWord.top, 133
      mov @stRectWord.bottom, 150
      mov @stRectWord.right, 555
      invoke DrawText, @hDc, addr word4, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER     

      mAddFrog leaf2.x, leaf2.y

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

    .if status == 4
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, leaf1.x, leaf1.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf2.x, leaf2.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf3.x, leaf3.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      maddText addr word1, leaf1.x, leaf1.y
      maddText addr word2, leaf2.x, leaf2.y
      maddText addr word3, leaf3.x, leaf3.y

      mov @stRectWord.left, 450
      mov @stRectWord.top, 133
      mov @stRectWord.bottom, 150
      mov @stRectWord.right, 555
      invoke DrawText, @hDc, addr word4, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER      

      mAddFrog leaf3.x, leaf3.y

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

      .if status == 5
        mov eax, hBitmapBG3
        mov hBitmapBG, eax
      ;add leaf
      invoke CreateCompatibleDC, @hDc
      mov @hDcLeaf, eax ; Leaf DC
      invoke SelectObject, @hDcLeaf, hBitmapLeaf
      invoke TransparentBlt, @hDc, leaf1.x, leaf1.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf2.x, leaf2.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      invoke TransparentBlt, @hDc, leaf3.x, leaf3.y, 156, 67, @hDcLeaf, 0, 0, 156, 67, 0ffffffh
      maddText addr word1, leaf1.x, leaf1.y
      maddText addr word2, leaf2.x, leaf2.y
      maddText addr word3, leaf3.x, leaf3.y

      mov @stRectWord.left, 450
      mov @stRectWord.top, 133
      mov @stRectWord.bottom, 150
      mov @stRectWord.right, 555
      invoke DrawText, @hDc, addr word4, -1, addr @stRectWord, DT_SINGLELINE or DT_CENTER or DT_VCENTER     

      invoke DeleteDC, @hDcLeaf
      invoke DeleteDC, @hDcFrog
    .endif

    ;invoke DrawText, @hDc, addr szText, -1, addr @stRect, DT_SINGLELINE or DT_CENTER or DT_VCENTER

    invoke EndPaint, hWnd, addr @stPs
  .elseif eax == WM_KEYDOWN
    invoke ProcKeydown, hWnd, uMsg, wParam, lParam
  .elseif eax == WM_CHAR
    invoke ProcChar, hWnd, uMsg, wParam, lParam
  .elseif eax == WM_CREATE
    ; do nothing
  .elseif eax == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, NULL
  .elseif eax == WM_COMMAND
    .if wParam == IDM_NEWGAME
      invoke MessageBox, hWinMain, addr szHeroHealth, addr szHeroAttack, MB_OK
    .elseif wParam == IDM_QUIT
      invoke PostQuitMessage, 0
    .endif
  .else
    ; default process
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
  .endif
  xor eax, eax
  ret
_ProcWinMain endp

_WinMain proc
  local @stWndClass: WNDCLASSEX
  local @stMsg: MSG
  local @hMenu: HMENU
  local @hIcon: HICON
  invoke GetModuleHandle, NULL
  mov hInstance, eax
  mov @stWndClass.hInstance, eax
  invoke RtlZeroMemory, addr @stWndClass, sizeof @stWndClass 
  mov @stWndClass.hIcon, eax
  mov @stWndClass.hIconSm, eax

  invoke LoadCursor, 0, IDC_ARROW
  mov @stWndClass.hCursor, eax ; 用LoadCursor为光标句柄赋值
  
  mov @stWndClass.cbSize, sizeof WNDCLASSEX
  mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW
  mov @stWndClass.lpfnWndProc, offset _ProcWinMain
  mov @stWndClass.hbrBackground, COLOR_WINDOW + 1
  mov @stWndClass.lpszClassName, offset szClassName

  invoke CreateMenu
  mov hMenu, eax
  invoke AppendMenu, hMenu, 0, IDM_NEWGAME, offset szMenuNewGame
  invoke AppendMenu, hMenu, 0, IDM_QUIT, offset szMenuQuit

  invoke LoadMenu, hInstance, IDM_MAIN
  mov @hMenu, eax

  invoke RegisterClassEx, addr @stWndClass
  ; create a client edged window
  ; whose class is 'szClassName',
  ; and caption is 'szCaptionMain'
  ;  
  invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr szClassName, addr szCaptionMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU, 0, 0, 810, 670+50, NULL, hMenu, hInstance, NULL
  mov hWinMain, eax ; mark hWinMain as the main window
  invoke SetTimer, hWinMain, 0, 100, ProcTimer
  invoke UpdateWindow, hWinMain ; send WM_PRINT to hWinMain
  invoke SendMessage, hWinMain, WM_SETICON, ICON_BIG, hIcon
  invoke ShowWindow, hWinMain, SW_SHOWNORMAL ; show window in a normal way
  ; main loop
  .while 1
    invoke GetMessage, addr @stMsg, NULL, 0, 0
    .break .if eax == 0 ; WM_QUIT => eax == 0
    invoke TranslateMessage, addr @stMsg
    invoke DispatchMessage, addr @stMsg
  .endw
  ret
_WinMain endp


__main proc
  call ImagesInit
  invoke _WinMain
  invoke ExitProcess, 0
__main endp
end __main