Scriptname sPDTransformQuest extends Quest  
import utility
import debug
import game

;  	  ______________________________
; 	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;  	/   	Version control  	  /
; 	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Float Property Version
	float function get()
		return 1.2 ; Define the mod version here
	endfunction
endProperty

int iModCount = 0

Event OnInit() ; First time
	Update()
	setstage(1)
endevent

Event OnPlayerLoadGame()
	Maint()
endEvent

;    ______________________
;   /		      	   /
;  /   	Variables  	  /
; /______________________/

Float fVersionScript = 0.0
string PDplugin = "PlayableDragon.esp"
Spell OriginalFireSpell2
Spell OriginalFireSpell3
Spell OriginalFrostSpell2
Spell OriginalFrostSpell3

;    ______________________
;   /		      	   /
;  /   	Functions   	  /
; /______________________/

function Maint()
	if GetModCount() != iModCount
		Update()
	endif
	if fVersionScript != Version
		fVersionScript = Version
		;Do something if the version changes blah blah
		setstage(1)
	endif
endFunction

function Update()
	iModCount = GetModCount()
	GetOfficialSkins()
		OriginalFireSpell2 = FireBreathShout.GetNthSpell(1)
		OriginalFireSpell3 = FireBreathShout.GetNthSpell(2)
		OriginalFrostSpell2 = FrostBreathShout.GetNthSpell(1)
		OriginalFrostSpell3 = FrostBreathShout.GetNthSpell(2)
endFunction

Function DetectPlugins()
;Trace("Compatibility: Burning Skies is checking for plugins")
Trace("==========" + PDplugin + ": ERRORS RELATED TO MISSING FILES SHOULD BE IGNORED!")
;		HasSkyUI = (GetFormFromFile(0x814, "SkyUI.esp") as Quest) as Bool	; SKI_MainInstance
;		HasRaceMenuPlugin = (GetFormFromFile(0x801, "RaceMenuPlugin.esp") as Quest) as Bool ;RaceMenuPlugin
		bDawnguardDLC = (GetFormFromFile(0x2c09, "Dawnguard.esm") as Quest) as Bool	; DLC1Init
		bDragonbornDLC = (GetFormFromFile(0x16e02, "Dragonborn.esm") as Quest) as Bool	; DLC2Init
	Trace("========== Scan complete.")
endFunction


Function GetOfficialSkins()
;Vanilla skins are set in the properties window
;DragonSkin = new Armor[20]
;		DragonSkin[0] = (GetFormFromFile(0x86810, "Skyrim.esm") as Armor);Regular
;		DragonSkin[1] = (GetFormFromFile(0x87557, "Skyrim.esm") as Armor);Blood aka Forest
;		DragonSkin[2] = (GetFormFromFile(0x85808, "Skyrim.esm") as Armor);Frost aka Snow
;		DragonSkin[3] = (GetFormFromFile(0xebc0b, "Skyrim.esm") as Armor);Fire aka Odahviing
;		DragonSkin[4] = (GetFormFromFile(0xb9c2d, "Skyrim.esm") as Armor);Gray aka Paarthurnax
;		DragonSkin[5] = (GetFormFromFile(0xcee3d, PDplugin) as Armor);Skeletal aka Underskin
;		DragonSkin[6] = (GetFormFromFile(0x87556, "Skyrim.esm") as Armor);Elder aka Tundra
;		DragonSkin[7] = (GetFormFromFile(0x10e3c5, "Skyrim.esm") as Armor);Ancient aka Boss
;		DragonSkin[8] = (GetFormFromFile(0xCCDEC, PDplugin) as Armor);Alduin
;		DragonSkin[9] = (GetFormFromFile(0xf805a, PDplugin) as Armor);Avatar
	DetectPlugins()
		int Index = 9
; All variables with Num in the name will be accessed from the MCM menu.
	If bDawnguardDLC ;if valid Dawnguard is present
		Index += 1
	indexDGRevered = Index
		DragonSkin[Index] = (GetFormFromFile(0x38ce, "Dawnguard.esm") as Armor);Revered aka DLC1DragonIceLake DG
		Index += 1
	indexDGLegendary = Index
		DragonSkin[Index] = (GetFormFromFile(0x14eab, "Dawnguard.esm") as Armor);Legendary aka Purple DG
		Index += 1
	indexDGUndead = Index
		DragonSkin[Index] = (GetFormFromFile(0xCC888, PDplugin) as Armor);Undead aka Durnehviir DG
		;DurnehviirFeet = (GetFormFromFile(0x11a6e, "Dawnguard.esm") as Armor)
	endif
	If bDragonbornDLC ; Dragonborn is present
		Index += 1
	indexDBSerpentine = Index
		DragonSkin[Index] = (GetFormFromFile(0x2c88e, "Dragonborn.esm") as Armor);Serpentine aka DLC2DragonBlack DB
	EndIf
endfunction

Armor Function GetActorDragonSkin(actor akActor)
Armor myArmor = (akActor.GetWornForm(0x00000004) as armor)
	if !myArmor
	myArmor = akActor.GetLeveledActorBase().GetSkin()
		if !myArmor
		myArmor = akActor.GetRace().GetSkin()
			if !myArmor
				return None
			endif
		endif
	endif

			return myArmor
endFunction

Function StoreChosenSkin(Armor aInput)
	ChosenSkin = aInput
endFunction

Armor Function SetWearingSkin(bool bSetting = true)
if bSetting
	if ChosenSkin
		WearingSkin = ChosenSkin
	else
		WearingSkin = DragonSkin[(PDDragonType.GetValue() as int)]
	endif
else
WearingSkin = None
endif
		return WearingSkin
endfunction

Function HostileRelations(bool toBeast)
	If PDFriendlyNPCs.GetValueInt() < 1
		PlayerRef.SetAttackActorOnSight(toBeast)
   		Game.SendWereWolfTransformation(); Report werewolf crime
   		 int Index = 0
   		 int Max = PDHateFactionList.GetSize()
   		 while (Index < Max)
     		   (PDHateFactionList.GetAt(Index) as Faction).SetPlayerEnemy(toBeast)
       		 Index += 1
  		  endwhile
   		Game.SetPlayerReportCrime(!toBeast)
	endif
	If PDFriendlyDragons.GetValueInt() == 1
		If toBeast
		PlayerFaction.SetAlly(DragonFaction, false, false)
		else
		PlayerFaction.SetEnemy(DragonFaction, true, true)
		endif
	endif
endFunction

Function DynamicShoutChange(Actor akActor, string ShoutName, perk PerkCheck, bool toTransform = true)
If akActor.hasPerk(PerkCheck)
if toTransform
	if ShoutName == "Fire"
		FireBreathShout.SetNthSpell(1, PDVoiceFireball2)
		FireBreathShout.SetNthSpell(2, PDVoiceFireBreath3)
	elseif ShoutName == "Frost"
		FrostBreathShout.SetNthSpell(1, PDVoiceIceStorm2)
		FrostBreathShout.SetNthSpell(2, PDVoiceFrostBreath3)
	endif
else
	if ShoutName == "Fire"
		FireBreathShout.SetNthSpell(1, OriginalFireSpell2)
		FireBreathShout.SetNthSpell(2, OriginalFireSpell3)
	elseif ShoutName == "Frost"
		FrostBreathShout.SetNthSpell(1, OriginalFrostSpell2)
		FrostBreathShout.SetNthSpell(2, OriginalFrostSpell3)
	endif
endif
endif
return
endFunction

;    _____________________________________________________________________________________________________________________
;   /		      													 /
;  /  				 	Properties   									/
; /____________________________________________________________________________________________________________________/

sPD_MCM Property MCMscript Auto
Actor Property PlayerRef Auto
Race Property OriginalRace Auto
Armor Property ChosenSkin Auto
String Property sChosenSkin Auto
Armor Property WearingSkin Auto
GlobalVariable Property PDDragonType Auto
Armor[] Property DragonSkin Auto

Perk Property PDselfFire2 Auto
Perk Property PDselfFrost2 Auto

bool Property bDawnguardDLC Auto
bool Property bDragonbornDLC Auto

int property indexDGRevered auto
int property indexDGLegendary auto
int property indexDGUndead auto
int property indexDBSerpentine auto

GlobalVariable Property PDFriendlyNPCs Auto
GlobalVariable Property PDFriendlyDragons Auto
Formlist Property PDHateFactionList Auto
Faction Property PlayerFaction Auto
Faction Property DragonFaction Auto
Shout Property FireBreathShout Auto
Shout Property FrostBreathShout Auto
Spell Property PDVoiceFireball2 Auto
Spell Property PDVoiceIceStorm2 Auto
Spell Property PDVoiceFireBreath3 Auto
Spell Property PDVoiceFrostBreath3 Auto