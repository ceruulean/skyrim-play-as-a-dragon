Scriptname sPDNightEye extends activemagiceffect  
{Scripted effect for toggable PD Dragon Night Eye Spell}

import GlobalVariable

;======================================================================================;
;               PROPERTIES  /
;=============/

ImageSpaceModifier property IntroFX auto
{IsMod applied at the start of the spell effect}
ImageSpaceModifier property MainFX auto
{main isMod for spell}
ImageSpaceModifier property OutroFX auto
{IsMod applied at the end of the spell effect}
sound property IntroSoundFX auto ; create a sound property we'll point to in the editor
sound property OutroSoundFX auto ; create a sound property we'll point to in the editor
GlobalVariable Property PDNightEyeState auto
Spell Property ThisSpell Auto

Event OnEffectStart(Actor Target, Actor Caster)
int iNightEyeState = PDNightEyeState.GetValue() as int
	if iNightEyeState == 0
		PDNightEyeState.setValue(1.0)
		int instanceID = IntroSoundFX.play((target as objectReference))          ; play IntroSoundFX sound from my self
		introFX.apply()                                  ; apply isMod at full strength
			
			utility.wait(4.0)
			introFX.PopTo(MainFX)
	elseif iNightEyeState >= 1
		Target.DispelSpell(ThisSpell)
	endif
	
EndEvent

Event OnEffectEnd(Actor Target, Actor Caster)
		int instanceID = OutroSoundFX.play((target as objectReference))         ; play OutroSoundFX sound from my self
		MainFX.PopTo(OutroFX)
		introFX.remove()
		PDNightEyeState.setValue(0.0)
EndEvent