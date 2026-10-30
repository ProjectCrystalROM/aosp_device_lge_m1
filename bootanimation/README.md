# Project Crystal boot artwork

Owner-supplied PNG481x854 retained unchanged. Android boot animation canvas480x854
scales the frame by one pixel horizontally without clipping. One frame repeats at
1fps until Android requests exit. build-zip.py generates the ZIP_STORED archive as
part of the normal bootanimation.zip Make target; no binary ZIP is checked in.

The wallpaper is separately supplied as a native JPEG480x854 in overlay-crystal.
Launcher2 overlay fills the removed Dialer/SMS slots with CrystalGram and Camera;
all-apps remains rank2, Contacts and Browser retain their positions. No launcher
code fork or user-data clearing is needed. Existing personalized layouts/wallpapers
are not automatically reset; fresh defaults apply when their data is initialized.
