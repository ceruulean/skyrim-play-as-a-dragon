Scriptname sPD_HealthPerk extends activemagiceffect  

;HP equation best-fit based on vanilla NPC dragon values: health = 54.161(level) + 288.71

float fBaseHealth
float fFinalHealth
float fHealthAdded

Event OnEffectStart(Actor akTarget, Actor akCaster)
if akCaster.HasPerk(PDselfMassHP2)
	fBaseHealth = akTarget.GetBaseActorValue("health")
	fFinalHealth = (54.161 * (akTarget.GetLevel()) + 138.71) ;-150 hp because spell already adds 100hp+ 100 hp as base 
	fHealthAdded = fFinalHealth - fBaseHealth
	akTarget.SetActorValue("health", fFinalHealth)
endif
;debug.notification("uh")
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
if akCaster.HasPerk(PDselfMassHP2)
fBaseHealth = akTarget.GetBaseActorValue("health") - fHealthAdded
	akTarget.SetActorValue("health", fBaseHealth)
endif
;debug.notification("end")
endEvent

Perk Property PDselfMassHP2 auto