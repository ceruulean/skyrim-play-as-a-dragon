;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname sPD_QF_PDTransformQST Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerAlias
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerAlias Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;PlayerRef.RemoveSpell(PDTransform)
PlayerRef.RemoveSpell(PDBreathingContainer)
PlayerRef.RemoveSpell(PDCopySpell)
MCMscript.Uninstall()
stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
if PlayerRef.HasSpell(PDTransform) == false
PlayerRef.AddSpell(PDTransform)
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
PlayerRef.AddSpell(PDCopySpell)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto  

SPELL Property PDTransform  Auto  
SPELL Property PDBreathingContainer  Auto  
sPD_MCM Property MCMscript auto

SPELL Property PDCopySpell  Auto  
