Scriptname sPD_Transform extends ActiveMagicEffect  

Race Property PDDragonRace Auto
sPDTransformQuest Property TransformQST Auto
sPD_PlayerAlias Property AliasScript Auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
Race myRace = (akCaster.GetRace())
	AliasScript.GoToState("_Transforming")
	if myRace != PDDragonRace
		TransformQST.OriginalRace = myRace
		AliasScript.Transform(akCaster, PDDragonRace, true)
	else
		AliasScript.Transform(akCaster, (TransformQST.OriginalRace), false)
	endif
endEvent