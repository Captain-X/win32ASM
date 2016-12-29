include stdafx.inc
.data
bgm db 'images\\BG.wav',0
.code
invoke PlaySound, addr bgm, NULL, SND_FILENAME
end