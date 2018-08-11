;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname sPD_QF_PDCopyQST Extends Quest Hidden

;BEGIN ALIAS PROPERTY Alias_Dragon
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Alias_Dragon Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
if (TransformQSTScript.ChosenSkin)
	int choice2 = PD_Copy2.show() ; show clear menu
		if (choice2 == 0) ; Yes clear it
			;run clear code
			TransformQSTScript.StoreChosenSkin(none)
			TransformQSTScript.sChosenSkin = None
			PD_Copy3.show()
		elseif choice2 == 1
			;exit menu
		endif

else
		PD_NoDragonMemory.show()
endif

			Alias_Alias_Dragon.Clear()
			stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor aDragon = Alias_Alias_Dragon.GetReference() as Actor
int choice0

if aDragon
 choice0 = PD_Copy0.show() ; Show copy menu

	if choice0 == 0 ; yes, copy the appearance
				;run copy code

			Armor aSkin = TransformQSTScript.GetActorDragonSkin(aDragon)
				if aSkin
					TransformQSTScript.sChosenSkin =  aDragon.GetActorBase().GetName()
					TransformQSTScript.StoreChosenSkin(aSkin)
					PD_Copy1.show() ; show confirmation
					stop()
				else
					debug.trace("===== Playable Dragon: Cannot find dragon's skin!")
				endif

	elseif (choice0 == 1); chosen 'no' and chosen skin exists
		setstage(1); go to clear menu
	endif
else
PD_NoNearbydragons.show()
setstage(1)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Message Property PD_Copy0  Auto
Message Property PD_Copy1  Auto
Message Property PD_Copy2  Auto
Message Property PD_Copy3  Auto

sPDTransformQuest Property TransformQSTscript  Auto  

Message Property PD_NoNearbyDragons  Auto  

Message Property PD_NoDragonMemory  Auto  
