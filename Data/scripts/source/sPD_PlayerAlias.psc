Scriptname sPD_PlayerAlias extends ReferenceAlias 
import utility
import input
import game
import debug

bool bIsBeast
bool bHasFearfulPresence2
bool bCruise = false
bool bAscend = false
bool bSprint = false
string sAfterAnim
Float fDragonUpHeight = 500.0
Float fDragonTakeoffHeight = 700.0
Float fInitialGravity = 1.35
Float fDefaultJumpHeight = 76.0

Float fJumpFrequency = 0.6
int key_Jump

event OnInit()
;RegisterForSingleUpdate(1.0)
		fDefaultJumpHeight = GetGameSettingFloat("fJumpHeightMin")
endevent

event OnPlayerLoadGame()
;notification("_Empty State Load")
		SetGameSettingFloat("fJumpHeightMin", fDefaultJumpHeight)
		SetIniFloat("fInAirFallingCharGravityMult:Havok", fInitialGravity)
EndEvent 

;event OnUpdate()
;debug.notification(PlayerRef.GetAnimationVariableFloat("Speed"))
;RegisterForSingleUpdate(1.0)
;endEvent

; ========================== Transforming State =============================
State _Transforming
Event OnRaceSwitchComplete()
		debug.SendAnimationEvent(PlayerRef, sAfterAnim)
  StaticImodFX.PopTo(OutroImodFX)
		EffectShaderFX.Play(PlayerRef, 5.0)
		TransformQST.HostileRelations(bIsBeast)
	If bIsBeast
		RegisterForAnimationEvent(PlayerRef, "FlightTakeoffFDR")
		RegisterForAnimationEvent(PlayerRef, "HoverStartSafeFDR")
		RegisterForAnimationEvent(PlayerRef, "FlightHoveringFDR")
		RegisterForAnimationEvent(PlayerRef, "FlightCruisingFDR")
		RegisterForAnimationEvent(PlayerRef, "FlightLandingFDR")
		RegisterForAnimationEvent(PlayerRef, "FlightActionEntryEnd")
		RegisterForAnimationEvent(PlayerRef, "StartAnimatedCameraDelta")
		RegisterForAnimationEvent(PlayerRef, "EndAnimatedCamera")
		SetGameSettingFloat("fJumpHeightMin", fDragonTakeoffHeight)
	PDSoundBreathingContainer.cast(PlayerRef)
		GoToState("_Dragon")
	else
		UnregisterForAnimationEvent(PlayerRef, "FlightTakeoffFDR")
		UnregisterForAnimationEvent(PlayerRef, "HoverStartSafeFDR")
		UnregisterForAnimationEvent(PlayerRef, "FlightHoveringFDR")
		UnregisterForAnimationEvent(PlayerRef, "FlightCruisingFDR")
		UnregisterForAnimationEvent(PlayerRef, "FlightLandingFDR")
		UnregisterForAnimationEvent(PlayerRef, "FlightActionEntryEnd")
		UnregisterForAnimationEvent(PlayerRef, "StartAnimatedCameraDelta")
		UnregisterForAnimationEvent(PlayerRef, "EndAnimatedCamera")
		UnregisterForAllControls()
		SetGameSettingFloat("fJumpHeightMin", fDefaultJumpHeight)
	;SetIniFloat("fInAirFallingCharGravityMult:Havok",fInitialGravity)
	PlayerRef.DispelSpell(PDSoundBreathingContainer)
		GoToState("")
	endif
		wait(3.5)
		debug.SendAnimationEvent(PlayerRef, "bleedoutstop")
endEvent
endState

; ========================== Dragon State =============================
State _Dragon
  Event OnBeginState()
	key_Jump = GetMappedKey("Jump")
	TransformQST.DynamicShoutChange(PlayerRef, "Fire", PDselfFire2)
	TransformQST.DynamicShoutChange(PlayerRef, "Frost", PDselfFrost2)
	RegisterForControl("Jump")
  EndEvent

event OnPlayerLoadGame()
;notification("_Dragon State Load")
		int iStateCk = PlayerRef.GetAnimationVariableInt("iState")
	If iStateCk == 0; on the ground
		SetGameSettingFloat("fJumpHeightMin", fDragonTakeoffHeight)
	elseif iStateCk == 1; Cruise flight
		SetGameSettingFloat("fJumpHeightMin", fDragonUpHeight)
	elseif iStateCk == 2; Is hovering
		SetIniFloat("fInAirFallingCharGravityMult:Havok", -0.1)
	endif
		TransformQST.DynamicShoutChange(PlayerRef, "Fire", PDselfFire2)
		TransformQST.DynamicShoutChange(PlayerRef, "Frost", PDselfFrost2)
	PDSoundBreathingContainer.cast(PlayerRef)
EndEvent 

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "FlightTakeoffFDR"
			RegisterForControl("Sprint")
			SetGameSettingFloat("fJumpHeightMin", fDragonTakeoffHeight)
	elseif asEventName == "FlightHoveringFDR"
			;SetGameSettingFloat("fJumpHeightMin", fDragonHoverHeight)
			;RegisterForSingleUpdate(1.0)
	elseif asEventName == "HoverStartSafeFDR"
			SetIniFloat("fInAirFallingCharGravityMult:Havok", -0.1)
			TapKey(key_Jump)
	elseif asEventName == "FlightCruisingFDR"
		if !bCruise
			SetGameSettingFloat("fJumpHeightMin", fDragonUpHeight)
		endif
			SetIniFloat("fInAirFallingCharGravityMult:Havok", 1.35)
	elseif asEventName == "FlightLandingFDR"
			UnregisterForControl("Sprint")
			SetSprinting(false)
			SetGameSettingFloat("fJumpHeightMin", fDragonTakeoffHeight)
			SetIniFloat("fInAirFallingCharGravityMult:Havok", 1.35)
	elseif asEventName == "FlightActionEntryEnd"
actor shit = PlayerRef.GetCombatTarget()
	;debug.notification(shit)
;shit.TranslateToRef(PlayerRef, 300)
		PDGrabFlightSpell.Cast(PlayerRef, PlayerRef)
	elseif asEventName == "StartAnimatedCameraDelta"
		SetSprinting()
	elseif asEventName == "EndAnimatedCamera"
		SetSprinting(false)
	endif
endEvent

Event onUpdate()
	If IsKeyPressed(key_Jump)
			TapKey(key_Jump)
			RegisterForSingleUpdate(fJumpFrequency)
	else
			ToggleAscend(false)
	endif
endEvent

Event OnControlDown(string control)
If !IsInMenuMode();					 make sure player isnt in menu mode or something
	If (control == "Sprint")
SendAnimationEvent(PlayerRef,"sprintStart")
	elseif control == "Jump"
;	notification("Jump")
		if !bAscend
			ToggleAscend(true)
		endif
	endif
EndIf
endEvent

Event OnControlUp(string control, Float HoldTime)
If !IsInMenuMode()
	If (control == "Sprint")
SendAnimationEvent(PlayerRef,"sprintStop")
	endif
endif
EndEvent

Event OnSpellCast(Form akSpell)
if bIsBeast && bHasFearfulPresence2
  Spell spellCast = akSpell as Spell
  if spellCast == VoiceDismayingShout1
	PDperkFearfulPresence1.Cast(PlayerRef)
	if PlayerRef.GetVoiceRecoveryTime() > fDismayRecover1
	PlayerRef.SetVoiceRecoveryTime(fDismayRecover1)
	endif
  elseif spellCast == VoiceDismayingShout2
	PDperkFearfulPresence2.Cast(PlayerRef)
	if PlayerRef.GetVoiceRecoveryTime() > fDismayRecover2
	PlayerRef.SetVoiceRecoveryTime(fDismayRecover2)
	endif
  elseif spellCast == VoiceDismayingShout3
	PDperkFearfulPresence3.Cast(PlayerRef)
	if PlayerRef.GetVoiceRecoveryTime() > fDismayRecover3
	PlayerRef.SetVoiceRecoveryTime(fDismayRecover3)
	endif
  endIf
endif
endEvent

Event OnEndState()
	UnregisterForControl("Jump")
	SetGameSettingFloat("fJumpHeightMin", fDefaultJumpHeight)
	SetIniFloat("fInAirFallingCharGravityMult:Havok", fInitialGravity)
	TransformQST.DynamicShoutChange(PlayerRef, "Fire", PDselfFire2, false)
	TransformQST.DynamicShoutChange(PlayerRef, "Frost", PDselfFrost2, false)
	SetSprinting(false)
  EndEvent
endState


; +++++++++++++++++++++++++++++ Functions ++++++++++++++++++++++++++++

function ToggleAscend(bool bToggle)
		bAscend = bToggle
	if bAscend
;		debug.notification("Ascend start")
		SetGameSettingFloat("fJumpHeightMin", fDragonUpHeight)
		RegisterForSingleUpdate(fJumpFrequency)
	else
;		notification("release me")
		UnregisterForUpdate()
	endif
endFunction


function Transform(actor Caster, race toRace, bool bBeast)

	if PDFastTransform.GetValueInt() == 1
	FastTransform(Caster, toRace, bBeast)
		return
	endif

;sAfterAnim = sAnimEvent
;debug.SendAnimationEvent(Caster, sAnimEvent)
       		Wait(3)
		IntroImodFX.apply()
		NPCDragonDeathSequenceExplosion.Play(Caster)
		VFXSpell.Cast(Caster)
       		Wait(2.5)
		StaticImodFX.apply()
		bIsBeast = bBeast
		bHasFearfulPresence2 = Caster.HasPerk(PDselfFearfulPresence2)
		Caster.SetRace(toRace)

	if bBeast
		sAfterAnim = "bleedOutStartSpecial"
		Caster.EquipItem(TransformQST.SetWearingSkin(), true, true)
	else
		sAfterAnim = "bleedOutStart"
		Caster.UnequipItem(TransformQST.WearingSkin, false, true)
		Caster.Removeitem(TransformQST.WearingSkin, 1, True, none)
	endif
endfunction

function FastTransform(actor Caster, race toRace, bool bBeast)
		sAfterAnim = ""
		IntroImodFX.apply()
		NPCDragonDeathSequenceExplosion.Play(Caster)
		VFXSpell.Cast(Caster)
		StaticImodFX.apply()
		bIsBeast = bBeast
bHasFearfulPresence2 = Caster.HasPerk(PDselfFearfulPresence2)
		Caster.SetRace(toRace)

	if bBeast
		Caster.EquipItem(TransformQST.SetWearingSkin(), true, true)
	else
		Caster.UnequipItem(TransformQST.WearingSkin, false, true)
		Caster.Removeitem(TransformQST.WearingSkin, 1, True, none)
	endif
endFunction

Function SetSprinting(bool toSprint = true)
if toSprint && !bSprint
	;SendAnimationEvent(PlayerRef,"sprintStart")
	PlayerRef.Modactorvalue("speedmult", 50)
	PlayerRef.Modactorvalue("CarryWeight", 0.1); speedmult applies when updated animation like adjusting inventory weight
	SetGameSettingFloat("fJumpHeightMin", fDragonTakeoffHeight)
	SetIniFloat("fInAirFallingCharGravityMult:Havok", 1.35)
elseif !toSprint && bSprint
	PlayerRef.Modactorvalue("speedmult", -50)
	PlayerRef.Modactorvalue("CarryWeight", -0.1)
	SetGameSettingFloat("fJumpHeightMin", fDragonUpHeight)
endif
		bSprint = toSprint
endFunction

; ************************** Properties *******************************
Actor Property PlayerRef Auto
Actor Property PDDummy Auto
Race Property PDDragon Auto
sPDTransformQuest Property TransformQST Auto
;sPD_FlyingScript Property FlyingScript Auto
ImageSpaceModifier property StaticImodFX auto
ImageSpaceModifier property OutroImodFX auto
ImageSpaceModifier property IntroImodFX auto
EffectShader property EffectShaderFX auto
Spell Property VFXSpell Auto
Spell Property PDSoundBreathingContainer Auto
Sound Property NPCDragonDeathSequenceExplosion Auto

Float Property fDismayRecover1 = 3.0 Auto
Float Property fDismayRecover2 = 6.0 Auto
Float Property fDismayRecover3 = 9.0 Auto
Perk Property PDselfFearfulPresence2 Auto
Perk Property PDselfFire2 Auto
Perk Property PDselfFrost2 Auto
Spell Property VoiceDismayingShout1 Auto
Spell Property VoiceDismayingShout2 Auto
Spell Property VoiceDismayingShout3 Auto
Spell Property PDperkFearfulPresence1 Auto
Spell Property PDperkFearfulPresence2 Auto
Spell Property PDperkFearfulPresence3 Auto
Spell Property PDGrabFlightSpell Auto
Globalvariable Property PDFastTransform Auto