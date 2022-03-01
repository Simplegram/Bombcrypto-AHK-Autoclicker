#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

;====================
; V3 = Pixel trigger
;====================

global logfile_path := "E:\Projects\AHK\log\logfile.txt"
global loop_time := 300000 ; in miliseconds
global max_time := 500 ; in minutes

global time := 0
global stop := 0

;====================
; GUI Initialization
;====================

; Start and stop button init
Gui, Add, Text, x10 y7, Start
Gui, Add, Button, x13 y25 gbutton_start vStartProg, Start Program
Gui, Add, Button, x90 y25 gbutton_stop vStopProg, Stop Program
GuiControl, Disable, StopProg

; Status init
Gui, Add, Text, x180 y7, Program Status
Gui, Add, Text, x183 y27 vProgramStatus, Not running

; Time display init
Gui, Add, Text, x10 y53, Timer:
Gui, Add, Text, w50 x55 y53 vTimeDisplay, %timer%

; Log display init
Gui, Add, Text, x10 y135, Latest Log:
Gui, Add, Text, w200 x10 y155 vProgramLog, None

; Open log button
Gui, +AlwaysOnTop
Gui, Add, Button, x5 y190 gopen_log, Open Log

; Show GUI
Gui, Show, w270 h220 x40 y650, Bomb Crypto v3 GUI
return

;====================
; Functions
;====================

; Get pixel color
get_color(x, y){
	PixelGetColor, color, x, y, RGB
	return %color%
}

; Log text into ProgramLog and logfile.txt
log(text) {
	GuiControl, , ProgramLog, % text
	utc_time := A_NowUTC
	FormatTime, TimeString, utc_time, ddMMMyyyy-hh:mm:ss
	FileAppend, %TimeString%> %text% `n, % logfile_path
	return
}

; Update time display
u_time(text){
	GuiControl, , TimeDisplay, % text
}

; Mouse click
mclick(x, y){
	MouseClick, , x, y, , 0,
	return
}

; Move mouse
mouse_move(x, y){
	MouseMove, %x%, %y%, 0
	return
}

; Scroll down
w_down(x, y, count){
	Sleep, 500
	MouseClick, WheelDown, x, y, count, 0,
	return
}

;====================
; Actions
;====================

; Initialize variables and actions
var_init(){
	time := 5
	stop := 0
	log("Program started")
	Sleep, 2000
	prtsc()
	u_time(0)
	return
}

; Take screenshot
prtsc(){
	Send #{PrintScreen}
	log("Screenshot taken")
}

; Anti AFK measure
anti_afk(){
	MouseClick, , 1440, 225, , 0,
	Sleep, 2500
	MouseClick, , 1315, 330, , 0,
	log("Anti-AFK executed")
	return
}

; Detect treasure hunt
in_thunt(){
	if(get_color(1450, 252) == 0xC63D3A){
		return 1
	} else {
		return 0
	}
}

; Detect logo screen
in_logo(){
	if(get_color(985, 905) == 0x150F1B){
		return 1
	} else {
		return 0
	}
}

; Open charater menu
char_menu(){
	prtsc()
	success := 0
	Loop {
		mclick(985, 905)
		success += 1
		Sleep, 1000
		if(get_color(985, 905) == 0xF5F1ED){
			mclick(985, 905)
			success := 1
			break
		} 
		if(success == 60){
			break
		}
	} 
	
	if(success == 1){
		return 1
	} else {
		return 0
	}
	return 0
}

; Work hero
hero_on(x, y, color){
	While(get_color(x, y) != 0x5B875F){
		Sleep, 1000
	}
	
	prtsc()
	Sleep, 2000
	
	global success := 0
	mclick(x, y)
	Loop {
		success := 0
		Loop {
			success += 1
			Sleep, 1000
			if(get_color(520, y) == %color%){
				break
			} 
			if(success == 60){
				break 2
			}
		}
		
		success := 0
		Loop {
			mclick(1055, 325)
			success += 1
			Sleep, 1000
			if(get_color(985, 880) == 0xDBA46E){
				success := 1
				break 2
			} 
			if(success == 60){
				break 2
			}
		}
	}
	
	prtsc()
	
	if(success == 1){
		return 1
	} else {
		return 0
	}
	return 0
}

; Handles input error (Refresh page)
error_handler(){
	log("Handling error...")
	if(get_color(1450, 252) != 0xC63D3A){
		Loop {
			Loop {
				log("Refreshing page")
				
				Send, ^{F5}
				While(get_color(985, 905) != 0x231F20){
					Sleep, 1000
				}
				
				While(get_color(985, 905) != 0x150F1B){
					Sleep, 1000
				}
				
				log("Game loading complete, joining")
				
				mouse_move(985, 905)
				mclick(985, 800)
				
				success := 0
				While(get_color(985, 765) != 0xF7E0C2){
					Sleep, 1000
					success += 1
					if(success == 20){
						log("Timeout")
						break 2
					}
				}
				
				success := 0
				mclick(985, 740)
				While(get_color(200, 350) != 0xFFFFFF){
					Sleep, 1000
					success += 1
					if(success == 40){
						log("Timeout")
						break 2
					}
				}
				
				While(get_color(400, 460) != 0x037DD6){
					w_down(200, 350, 2)
					Sleep, 1000
				}
				
				mclick(400, 460)
				success := 0
				While(get_color(968, 830) != 0x7EC9FF){
					Sleep, 1000
					success += 1
					if(success == 60){
						log("Timeout")
						break 2
					}
				}
				
				log("Join successful, opening map")
				
				success := 0
				Loop {
					mclick(985, 600)
					success += 1
					Sleep, 1500
					if(get_color(1450, 252) == 0xC63D3A){
						log("Map opened")
						break 3
					}
					if(success == 40){
						log("Timeout")
						break 2
					}
				}
			}
			log("Refresh failed")
		}
	} 
	return
}

; When start button is pressed
button_start:
GuiControl, Disable, StartProg
GuiControl, Enable, StopProg
stop := 0
main(loop_time)
return

; When stop button is pressed (Stop all action)
button_stop:
GuiControl, Enable, StartProg
GuiControl, Disable, StopProg
stop := 1
log("Program stopped")
return

; Open log
open_log:
Run, % logfile_path
log("Log opened")
return

; Emergency Exit
^x::
log("Program stopped")
ExitApp

GuiClose:
ExitApp

;====================
; Int main
;====================

; Main loop
main(loop_time){
	var_init()
	Loop {
		if(time > max_time) or (stop == 1){
			break
		} 
		
		if(in_thunt() == 1) && (stop == 0){
			if(Mod(time, 165) == 0){
				if(char_menu() == 1){
					if(hero_on(880, 625, 0xFCB64D) == 1){
						log("Doge active")
						prtsc()
					} 
				} 
			} else if(Mod(time, 310) == 0){
				if(char_menu() == 1){
					if(hero_on(880, 715, 0x159002) == 1){
						log("Witch active")
						prtsc()
					} 
				} 
			} else if(Mod(time, 315) == 0){
				if(char_menu() == 1){
					if(hero_on(880, 805, 0xD5E3C7) == 1){
						log("Pepe low active")
						prtsc()
					} 
				}  
			} 
			else {
				anti_afk()
			}
		} else if(stop == 0) {
			error_handler()
		} else {
			error_handler()
		}
		
		Sleep, %loop_time%
		
		if(stop == 0){
			u_time(time)
			time += 5
		}
	}
	log("Program finished")
	return
}

;====================
; Testers
;====================

^j::
mouse_move(520, 805)
MsgBox, % get_color(520, 805)
return

;====================
; Color data
;====================

;0x150F1B Very Dark Blue (Main menu color)
;0xFFFFFF White
;0x7EC9FF Light Blue
;0xC63D3A Light Brow (Chest color)
;0xFFFBF7 Light Grey (Knight menu normal)
;0xF5F1ED Light Grey (Knight menu hover)
;0x231F20 Black Unity
;0x5B875F Dark Green (Hero off)
;0x82C188 Light Green (Hero on)
;0xE6B7A7 Cream (Hero menu background)
;0xDBA46E Map background
;0x037DD6 Metamask blue

;0xFCB64D Doge color (Orange)
;0x159002 Witch color (Green)
;0xD5E3C7 Pepe color (White-ish Green)
;0xE0413C Knight color (Red)
