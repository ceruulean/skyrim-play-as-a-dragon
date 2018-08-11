Scriptname sPD_MCM extends SKI_ConfigBase  

event OnConfigInit()
; Vanilla types defined in properties
;array_Type = new string[20]
;	array_Type[0] = "Regular"
;	array_Type[1] = "Blood"
;	array_Type[2] = "Frost"
;	array_Type[3] = "Fire"
;	array_Type[4] = "Gray"
;	array_Type[5] = "Skeletal"
;	array_Type[6] = "Elder"
;	array_Type[7] = "Ancient"
;	array_Type[8] = "Dark"
;	array_Type[9] = "Avatar"
	DLCTypeUpdate()

; defined as properties in .esp for faster load?
;	Pages = new string[3]
;	Pages[0] = "Intro"
;	Pages[1] = "Settings"
;	Pages[2] = "Perks"
endEvent

event OnConfigOpen()
	iType = PDDragonType.GetValueInt()
	bAutoLand = PDAutoLand.GetValueInt() as bool
	bManFactionFriendly = PDFriendlyNPCs.GetValueInt() as bool
	bFastTransform = PDFastTransform.GetValueInt() as bool
	bChosenSkin = TransformQST.ChosenSkin
	bHasCopySpell = PlayerRef.hasSpell(PDCopySpell)

	if bChosenSkin
		iDisableTypeMenu = OPTION_FLAG_DISABLED
		iDisableChosenSkin = 0
	else
		iDisableTypeMenu = 0
		iDisableChosenSkin = OPTION_FLAG_DISABLED
	endif
endEvent

	int blah6
	int blah77
	int blah8

event OnPageReset(string page)
SetCursorFillMode(TOP_TO_BOTTOM)
	if (page == "")
		int blah92 = AddTextOption("Play As a Dragon", "")
		int blah91 = AddTextOption("", "created by Ceruulean")
	elseif (page == "Intro")
	int blah1 = AddHeaderOption("GROUND CONTROLS")
	int blah2 = AddTextOption("Takeoff", "Jump")
	int blah3 = AddTextOption("Lay down", "Sneak")
	int blah4 = AddTextOption("Bite", "Right Attack")
	int blah5 = AddTextOption("Tail slam", "Left Attack")
		blah6 = AddTextOption("Wing slam", "Dual Attack")
	SetCursorPosition(1)
	int blah11 = AddHeaderOption("AIR CONTROLS")
	int blah22 = AddTextOption("Flap", "Jump")
	int blah33 = AddTextOption("Dive", "Sprint")
	int blah44 = AddTextOption("Land", "Sneak")
	int blah55 = AddTextOption("Air swipe", "Left Power Attack")
		blah77 = AddTextOption("Roar", "Right Attack")
	elseIf (page == "Settings")
		AddHeaderOption("Options")
		AddToggleOptionST("TOGGLE_AutoLand", "Auto Land", bAutoLand)
		AddToggleOptionST("TOGGLE_FastTransform", "Fast Transform", bFastTransform)
		AddToggleOptionST("TOGGLE_HostileMan", "Friendly human NPCs", bManFactionFriendly)
		AddToggleOptionST("TOGGLE_HostileDragon", "Friendly dragon NPCs", bDragonFactionFriendly)
		SetCursorPosition(1)
		AddHeaderOption("Appearance")
		AddMenuOptionST("MENU_Type", "Dragon Type", array_Type[iType], iDisableTypeMenu)
		blah8 = AddTextOption("Copied Skin:", TransformQST.sChosenSkin, iDisableChosenSkin)
	AddToggleOptionST("TOGGLE_CopySpell", "Add Copy spell", bHasCopySpell)
	elseIf (page == "Perks")
		AddSliderOptionST("SLIDER_MassHP", "Increased Mass", iPerk_MassHPLvL, "{0}")
		AddSliderOptionST("SLIDER_Unarmed", "Unarmed Damage", iPerk_UnarmedLvL, "{0}")
		AddSliderOptionST("SLIDER_Shout", "Shout Cooldown", iPerk_ShoutLvL, "{0}")
		AddSliderOptionST("SLIDER_DiseaseResist", "Disease Resist", iPerk_DiseaseResistLvL, "{0}")
		AddSliderOptionST("SLIDER_FireBreath", "Fire Breath", iPerk_FireBreathLvL, "{0}")
		AddSliderOptionST("SLIDER_FrostBreath", "Frost Breath", iPerk_FrostBreathLvL, "{0}")
		AddToggleOptionST("TOGGLE_Perk_Intimidate", "Intimidation", bPerk_Intimidate)
		AddSliderOptionST("SLIDER_Dismay", "Dismay", iPerk_DismayLvL, "{0}")
		AddToggleOptionST("TOGGLE_Perk_Nighteye", "Nighteye", bPerk_NightEye)
		AddToggleOptionST("TOGGLE_Perk_PhysResist", "Physical Resistance", bPerk_PhysResist)
		AddSliderOptionST("SLIDER_Reflect", "Reflective Scales", iPerk_ReflectLvL, "{0}")
	endIf
endEvent

event OnOptionHighlight(int option)
	if option == blah6
		SetInfoText("Must be moving left or right. Moving left causes a left swing, and moving right causes a right swing.")
	elseif option == blah77
		SetInfoText("Must be in combat mode. Enter combat mode while hovering or on the ground.")
	elseif option == blah8
		SetInfoText("Using the Copy spell overrides the menu choice.")
	else
		SetInfoText("")
	endif
endEvent


;    _____________________________________________________________________________________________________________________
;   /		      													 /
;  />>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Settings > Appearance   								/
; /____________________________________________________________________________________________________________________/

state MENU_Type; MENU
	event OnMenuOpenST()
		SetMenuDialogStartIndex(iType)
		SetMenuDialogDefaultIndex(iType)
		SetMenuDialogOptions(array_Type)
	endEvent

	event OnMenuAcceptST(int index)
		iType = index
		SetMenuOptionValueST(array_Type[iType])
	endEvent

	event OnDefaultST()
		iType = 0
		SetMenuOptionValueST(array_Type[iType])
	endEvent

	event OnHighlightST()
		SetInfoText("Change dragon type.")
	endEvent
endState

state TOGGLE_CopySpell;
	event OnSelectST()
		bHasCopySpell = !bHasCopySpell
		SetToggleOptionValueST(bHasCopySpell)
	endEvent

	event OnDefaultST()
		bHasCopySpell = true
		SetToggleOptionValueST(bHasCopySpell)
	endEvent

	event OnHighlightST()
		SetInfoText("Adds a lesser power to copy any dragon's appearance")
	endEvent
endState

;    _____________________________________________________________________________________________________________________
;   /		      													 /
;  />>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Settings > Toggle								/
; /____________________________________________________________________________________________________________________/

state TOGGLE_AutoLand;
	event OnSelectST()
		bAutoLand = !bAutoLand
		SetToggleOptionValueST(bAutoLand)
	endEvent

	event OnDefaultST()
		bAutoLand = true
		SetToggleOptionValueST(bAutoLand)
	endEvent

	event OnHighlightST()
		SetInfoText("Land when you hit the ground.")
	endEvent
endState

state TOGGLE_HostileMan;
	event OnSelectST()
		bManFactionFriendly = !bManFactionFriendly
		SetToggleOptionValueST(bManFactionFriendly)
	endEvent

	event OnDefaultST()
		bManFactionFriendly = false
		SetToggleOptionValueST(bManFactionFriendly)
	endEvent

	event OnHighlightST()
		SetInfoText("Make human NPCs friendly in dragon form.")
	endEvent
endState


state TOGGLE_HostileDragon;
	event OnSelectST()
		bDragonFactionFriendly = !bDragonFactionFriendly
		SetToggleOptionValueST(bDragonFactionFriendly)
	endEvent

	event OnDefaultST()
		bDragonFactionFriendly = false
		SetToggleOptionValueST(bDragonFactionFriendly)
	endEvent

	event OnHighlightST()
		SetInfoText("Make dragon NPCs friendly in dragon form.")
	endEvent
endState

state TOGGLE_FastTransform;
	event OnSelectST()
		bFastTransform = !bFastTransform
		SetToggleOptionValueST(bFastTransform)
	endEvent

	event OnDefaultST()
		bFastTransform = false
		SetToggleOptionValueST(bFastTransform)
	endEvent

	event OnHighlightST()
		SetInfoText("Skips the transformation animations. Note: performing actions before the transformation completes can cause you to teleport to the sky.")
	endEvent
endState

;    _____________________________________________________________________________________________________________________
;   /					 										 /
;  />>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Perks  	 									/
; /____________________________________________________________________________________________________________________/

Function PerkSliderOpen(int clevel, int maxlevel)
		SetSliderDialogStartValue(clevel)
		SetSliderDialogDefaultValue(clevel)
		SetSliderDialogRange(0, maxlevel)
		SetSliderDialogInterval(1)
endFunction

state SLIDER_Unarmed;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_UnarmedLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfUnarmed, iPerk_UnarmedLvL, value as int)
		iPerk_UnarmedLvL = value as int
		SetSliderOptionValueST(iPerk_UnarmedLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfUnarmed, iPerk_UnarmedLvL, 0)
		iPerk_UnarmedLvL = 0
		SetSliderOptionValueST(iPerk_UnarmedLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Increase unarmed damage by 20. \n Level 2: Unarmed damage scales to health.")
	endEvent
endState

state SLIDER_MassHP;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_MassHPLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfMassHP, iPerk_MassHPLvL, value as int)
		iPerk_MassHPLvL = value as int
		SetSliderOptionValueST(iPerk_MassHPLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfMassHP, iPerk_MassHPLvL, 0)
		iPerk_MassHPLvL = 0
		SetSliderOptionValueST(iPerk_MassHPLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Gain an additional 50 health. \n Level 2: In dragon form, HP scales according to level.")
	endEvent
endState

state SLIDER_Shout;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_ShoutLvL, 5)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfShoutCool, iPerk_ShoutLvL, value as int)
		iPerk_ShoutLvL = value as int
		SetSliderOptionValueST(iPerk_ShoutLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfShoutCool, iPerk_ShoutLvL, 0)
		iPerk_ShoutLvL = 0
		SetSliderOptionValueST(iPerk_ShoutLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Shout cooldowns are reduced by 10%. \n Level 2: Shout cooldowns are reduced by 20%.\n Level 3: Shout cooldowns are reduced by 30%.\n Level 4: Shout cooldowns are reduced by 40%.\n Level 5: Shout cooldowns are reduced by 50%.")
	endEvent
endState

state SLIDER_DiseaseResist;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_DiseaseResistLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfResistDisease, iPerk_DiseaseResistLvL, value as int)
		iPerk_DiseaseResistLvL = value as int
		SetSliderOptionValueST(iPerk_DiseaseResistLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfResistDisease, iPerk_DiseaseResistLvL, 0)
		iPerk_DiseaseResistLvL = 0
		SetSliderOptionValueST(iPerk_DiseaseResistLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Gain 50% disease resist. \n Level 2: Immune to diseases.")
	endEvent
endState

state SLIDER_FireBreath;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_FireBreathLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfFire, iPerk_FireBreathLvL, value as int)
		iPerk_FireBreathLvL = value as int
		SetSliderOptionValueST(iPerk_FireBreathLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfFire, iPerk_FireBreathLvL, 0)
		iPerk_FireBreathLvL = 0
		SetSliderOptionValueST(iPerk_FireBreathLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Fire Breath scales to Destruction skill level. \n Level 2: While in dragon form, \"Toor\" and \"Shul\" have stronger effects.")
	endEvent
endState

state SLIDER_FrostBreath;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_FrostBreathLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfFrost, iPerk_FrostBreathLvL, value as int)
		iPerk_FrostBreathLvL = value as int
		SetSliderOptionValueST(iPerk_FrostBreathLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfFrost, iPerk_FrostBreathLvL, 0)
		iPerk_FrostBreathLvL = 0
		SetSliderOptionValueST(iPerk_FrostBreathLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Frost Breath scales to Destruction skill level. \n Level 2: While in dragon form, \"Krah\" and \"Diin\" have stronger effects.")
	endEvent
endState

state SLIDER_Dismay;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_DismayLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfFearfulPresence, iPerk_DismayLvL, value as int)
		iPerk_DismayLvL = value as int
		SetSliderOptionValueST(iPerk_DismayLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfFearfulPresence, iPerk_DismayLvL, 0)
		iPerk_DismayLvL = 0
		SetSliderOptionValueST(iPerk_DismayLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: Dismay scales to Illusion skill level. \n Level 2: While in dragon form, Dismay has an area of effect and a greatly reduced CD.")
	endEvent
endState

state SLIDER_Reflect;
	event OnSliderOpenST()
		PerkSliderOpen(iPerk_ReflectLvL, 2)
	endEvent

	event OnSliderAcceptST(float value)
		AddPerkArray(PDselfReflect, iPerk_ReflectLvL, value as int)
		iPerk_ReflectLvL = value as int
		SetSliderOptionValueST(iPerk_ReflectLvL)
	endEvent

	event OnDefaultST()
		AddPerkArray(PDselfReflect, iPerk_ReflectLvL, 0)
		iPerk_ReflectLvL = 0
		SetSliderOptionValueST(iPerk_ReflectLvL)
	endEvent

	event OnHighlightST()
		SetInfoText("Level 1: 20% chance to reflect damage. \n Level 2: While in dragon form, an additional 30% chance to deflect arrows.")
	endEvent
endState

state TOGGLE_Perk_Intimidate;
	event OnSelectST()
		bPerk_Intimidate = !bPerk_Intimidate
		SetToggleOptionValueST(bPerk_Intimidate)
	endEvent

	event OnDefaultST()
		bPerk_Intimidate = false
		SetToggleOptionValueST(bPerk_Intimidate)
	endEvent

	event OnHighlightST()
		SetInfoText("Increases intimidation factor in speech.")
	endEvent
endState

state TOGGLE_Perk_NightEye;
	event OnSelectST()
		bPerk_NightEye = !bPerk_NightEye
		SetToggleOptionValueST(bPerk_NightEye)
	endEvent

	event OnDefaultST()
		bPerk_NightEye = false
		SetToggleOptionValueST(bPerk_NightEye)
	endEvent

	event OnHighlightST()
		SetInfoText("Add nighteye ability")
	endEvent
endState

state TOGGLE_Perk_PhysResist;
	event OnSelectST()
		bPerk_PhysResist = !bPerk_PhysResist
		SetToggleOptionValueST(bPerk_PhysResist)
	endEvent

	event OnDefaultST()
		bPerk_PhysResist = false
		SetToggleOptionValueST(bPerk_PhysResist)
	endEvent

	event OnHighlightST()
		SetInfoText("Reduce incoming physical damage by 10%.")
	endEvent
endState

event OnConfigClose()

PDDragonType.SetValueInt(iType)
PDAutoLand.SetValue(bAutoLand as float)
PDFriendlyNPCs.SetValue(bManFactionFriendly as float)
PDFriendlyDragons.SetValue(bDragonFactionFriendly as float)
PDFastTransform.SetValue(bFastTransform as float)

AddSinglePerk(PDselfNightEye, bPerk_NightEye)
AddSinglePerk(PDselfIntimidate, bPerk_Intimidate)
AddSinglePerk(PDselfPhysResist, bPerk_PhysResist)

if bHasCopySpell 
	PlayerRef.addSpell(PDCopySpell)
else
	PlayerRef.RemoveSpell(PDCopySpell)
endif

endEvent


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;   		      													 
;    				 	Functions   									
;____________________________________________________________________________________________________________________

function AddPerkArray(perk[] aPerk, int oldlevel, int newlevel)
if newlevel < oldlevel 
	int end = aPerk.length
	while end > newlevel 
	PlayerRef.RemovePerk(aPerk[end])
	end -= 1
	endwhile
elseif newlevel > oldlevel
	int i = 0
	while i <= newlevel
	PlayerRef.AddPerk(aPerk[i])
	i += 1
	endwhile
endif
endFunction

function AddSinglePerk(perk aP, bool bol)
if bol
	PlayerRef.Addperk(aP)
else
	PlayerRef.removeperk(aP)
endif
endFunction

Function DLCTypeUpdate()
	int test = TransformQST.indexDGRevered
if test > 0
	array_Type[test] = "Revered"
endif
	test = TransformQST.indexDGLegendary
if test > 0
	array_Type[TransformQST.indexDGLegendary] = "Legendary"
endif
	test = TransformQST.indexDGUndead
if test > 0
	array_Type[test] = "Undead"
endif
	test = TransformQST.indexDBSerpentine
if test > 0
	array_Type[test] = "Serpentine"
endif
endFunction

Function Uninstall()
		AddPerkArray(PDselfUnarmed, iPerk_UnarmedLvL, 0)
		AddPerkArray(PDselfMassHP, iPerk_MassHPLvL, 0)
		AddPerkArray(PDselfShoutCool, iPerk_ShoutLvL, 0)
		AddPerkArray(PDselfResistDisease, iPerk_DiseaseResistLvL, 0)
		AddPerkArray(PDselfFire, iPerk_FireBreathLvL, 0)
		AddPerkArray(PDselfFrost, iPerk_FrostBreathLvL, 0)
		AddPerkArray(PDselfFearfulPresence, iPerk_DismayLvL, 0)
		AddPerkArray(PDselfReflect, iPerk_ReflectLvL, 0)

AddSinglePerk(PDselfNightEye, false)
AddSinglePerk(PDselfIntimidate, false)
AddSinglePerk(PDselfPhysResist, false)
endFunction



;    ______________________
;   /		      	   /
;  /   	Variables   	  /
; /______________________/
Actor Property PlayerRef Auto
string[] Property array_Type Auto
string sIntro = "Blah blah"
int iType
bool bAutoLand = true
bool bFastTransform = false
bool bManFactionFriendly = false
bool bDragonFactionFriendly = false
bool bChosenSkin = false
bool bHasCopySpell = true
int iDisableTypeMenu = 0
int iDisableChosenSkin = 0
int iPerk_MassHPLvL = 0
int iPerk_UnarmedLvL = 0
int iPerk_ShoutLvL = 0
int iPerk_DiseaseResistLvL = 0
int iPerk_FireBreathLvL = 0
int iPerk_FrostBreathLvL = 0
int iPerk_DismayLvL = 0
int iPerk_ReflectLvL = 0
bool bPerk_NightEye = false
bool bPerk_Intimidate = false
bool bPerk_PhysResist = false

;    ______________________
;   /		      	   /
;  /   	Properties   	  /
; /______________________/

sPDTransformQuest Property TransformQST Auto
GlobalVariable Property PDDragonType Auto
GlobalVariable Property PDAutoLand Auto
GlobalVariable Property PDFriendlyNPCs Auto
GlobalVariable Property PDFriendlyDragons Auto
GlobalVariable Property PDFastTransform Auto
Perk[] Property PDselfFire Auto
Perk[] Property PDselfFrost Auto
Perk[] Property PDselfFearfulPresence Auto
perk[] Property PDselfMassHP Auto
perk[] Property PDselfUnarmed Auto
perk[] Property PDselfShoutCool Auto
perk[] Property PDselfResistDisease Auto
perk[] Property PDselfReflect Auto
Spell Property PDCopySpell Auto
Perk Property PDselfFrost2 Auto
perk Property PDselfNightEye Auto
perk Property PDselfIntimidate Auto
perk Property PDselfPhysResist Auto