# Match HUD port: BO3 widget map (from the game's own zones)

Read from `core_ui.ff` and `mp_common.ff` (Call of Duty: Black Ops III, Steam). The names below are the **Lua module paths the game ships**; module bodies are compiled bytecode, so child element names and data-model fields still have to be confirmed in-game (see *Next*).

## Menus
- `ui.uieditor.menus.hud.T7Hud_MP` builds the multiplayer match HUD (also `T7Hud`, `T7Hud_FR`).
- `ui.uieditor.widgets.HUD.SafeAreaContainers.T7Hud_MP_SafeAreaContainer` holds the HUD widgets.

## Widgets we restyle, with the Rust client's equivalent
| BO3 module group | Rust HUD piece |
|---|---|
| `HUD/core_AmmoWidget` (`AmmoWidgetMP`, `AmmoWidgetMPContainer`, `AmmoWidgetMP_ClipInfo`, `_TotalAmmo`, `_EquipmentInfo`) | ammo.rs: gun name, clip, reserve (bottom right) |
| `HUD/ScoreInfo` (`ScoreInfoContainer`, `ScoreInfo_FactionContainer`, `ScoreInfo_Timer`, `ScoreInfo_EnemyScorePanel`, `ScoreInfo_UserScorePanel`) | scorebar.rs: team scores, bars, clock (top centre) |
| `HUD/mp_scorestreakwidget` (`ScrStk_Container`, `ScrStk_Meter`, `ScrStk_Button`) | scorestreak column over the ammo box |
| `HUD/core_MapWidget`, `HUD/CompassMinimap*` | compass.rs / minimap |
| `HUD/CenterConsole`, `HUD/Console` | kill feed / notices |
| `HUD/DeadSpectate`, `HUD/Killcam`, `HUD/PrematchCountdown`, `HUD/Outcome` | splash.rs / killcam_skip.rs |

## Module files per group

### HUD/core_ammowidget
`ammowidget_abilityfill`, `ammowidget_abilityforestroke`, `ammowidget_abilityglow`, `ammowidget_arrowfull`, `ammowidget_attachmentinfo`, `ammowidget_backcircle`, `ammowidget_backline`, `ammowidget_ball`, `ammowidget_clipcontainerpress`, `ammowidget_clipcontainervalue`, `ammowidget_clipelements`, `ammowidget_clipinfodummy`, `ammowidget_clipmetercolor`, `ammowidget_equipmentempty`, `ammowidget_fist`, `ammowidget_heroabilitycontainer`, `ammowidget_heroabilityicon`, `ammowidget_heroabilityiconcontainer`, `ammowidget_heroabilityring`, `ammowidget_heroabilityringback`, `ammowidget_heroabilityringgold`, `ammowidget_heroabilityringpulse`, `ammowidget_heroweapon`, `ammowidget_heroweaponcontainer`, `ammowidget_iventorybox`, `ammowidget_knife`, `ammowidget_panelequip`, `ammowidget_sdbomb`, `ammowidget_semicircle`, `ammowidget_separator`, `ammowidget_textattachmentinfo`, `ammowidget_textattachmentinfofire`, `ammowidget_totalammo`, `ammowidgetmp`, `ammowidgetmp_abilityringbackdeplete`, `ammowidgetmp_clipcontainerhero`, `ammowidgetmp_clipcontainernew`, `ammowidgetmp_clipinfo`, `ammowidgetmp_dash`, `ammowidgetmp_equipglow`, `ammowidgetmp_equipmentinfo`, `ammowidgetmp_equipmentlethalitem`, `ammowidgetmp_equipmenttacticalitem`, `ammowidgetmp_helditem`, `ammowidgetmp_helditempanel`, `ammowidgetmp_heroweaponanimation`, `ammowidgetmp_lowammoglow`, `ammowidgetmp_lowammoglowcontainer`, `ammowidgetmp_panelcircle`, `ammowidgetmp_panelcirclecontainer`, `ammowidgetmp_panelcontainer`, `ammowidgetmp_panelequipcontainer`, `ammowidgetmp_totalammo`, `ammowidgetmpcontainer`

### HUD/scoreinfo
`rounds`, `roundscontainer`, `roundsunlimited`, `scoreinfo`, `scoreinfo_emblem`, `scoreinfo_enemyscorecontainer`, `scoreinfo_enemyscorepanel`, `scoreinfo_factioncontainer`, `scoreinfo_meter`, `scoreinfo_meterline`, `scoreinfo_panelcircle`, `scoreinfo_panelcircleinternal`, `scoreinfo_panelscale`, `scoreinfo_panelscalecontainer`, `scoreinfo_paneltimer`, `scoreinfo_paneltimerinternal`, `scoreinfo_rdtri`, `scoreinfo_rdtricont`, `scoreinfo_timer`, `scoreinfo_timernumber`, `scoreinfo_timesemi`, `scoreinfo_userscorepanel`, `scoreinfocontainer`, `statuscontainer`, `userscorecontainer`

### HUD/mp_scorestreakwidget
`scrstk_button`, `scrstk_buttoninternal`, `scrstk_combatefficiencybackglow`, `scrstk_combatefficiencypulse`, `scrstk_combatefficiencyscrollfx`, `scrstk_container`, `scrstk_meter`, `scrstk_meterinternal`, `scrstk_meterkarat`, `scrstk_meterkaratinner`, `scrstk_meterpanel`, `scrstk_numbermove`, `scrstk_panelcontainer`, `scrstk_updownarrow`

### HUD/core_mapwidget
`mapwidget`, `mapwidget_bartop`, `mapwidget_element`, `mapwidget_panelvignetteglow`, `mapwidget_panelvignetteleft`, `mapwidgetcontainer`

### HUD/centerconsole
`centerconsole`, `centerconsoleentry`, `centerconsoleentrycontainer`, `centerconsoleicon`, `centerconsoletext`

### HUD/console
`console`, `consoleentry`, `consoleentrycontainer`, `consoleicon`, `consoletext`

### HUD/deadspectate
`deadspectate`, `deadspectate_internal`, `deadspectate_spectatingbar`, `deadspectate_spectatingbarpc`, `deadspectate_spectatingmode`, `deadspectate_spectatingmodebuttonprompt`

### HUD/prematchcountdown
`prematchcountdown`, `prematchcountdown_beginsin`, `prematchcountdown_iconglowpanel`, `prematchcountdown_numbers`, `prematchcountdown_numbersinternal`, `prematchcountdown_title`

### HUD/outcome
`ffa_textlabels`, `matchbonuswidget`, `outcome`, `outcome_title_pnlcenter`, `outcome_title_pnlcenterint`, `outcome_title_pnlline`, `outcome_title_pnllineint`, `outcome_title_pnlur`, `outcome_title_pnlurint`, `timetobeatbox`, `winnerfactioninfo`

### HUD/killcam
`killcamheader`, `killcamkilledby`, `killcamkilledbyimage`, `killcamperkicon`

## Next (needs the game running)
1. Launch BOIII, join a private match, and dump the live widget tree of the HUD (child `id`s) to the console log.
2. Read the data-model fields these widgets bind to (clip, reserve, scores, timer) from the same run.
3. Write `data/ui_scripts/legacy_hud/__init__.lua`: wrap each constructor above, hide stock pieces by child id, add our panels (palette in `claude_hud.lua` of the Legacy Port).
