/**
 * @author Ormael
 * Demon area with lvl 41-61 demonic enemies. Each exploration will even slowly corrupt PC unless corruption is above 71.
 * Currently a Work in Progress.
 */

package classes.Scenes.Areas 
{
import classes.*;
import classes.GlobalFlags.kFLAGS;
import classes.Scenes.API.Encounters;
import classes.Scenes.API.GroupEncounter;
import classes.Scenes.Areas.BlightRidge.DemonScene;
import classes.Scenes.Areas.DefiledRavine.DemonSoldierScene;
import classes.Scenes.Dungeons.DemonLab;
import classes.Scenes.NPCs.AlvinaFollower;
import classes.Scenes.NPCs.Forgefather;
import classes.Scenes.SceneLib;

use namespace CoC;

	public class DefiledRavine extends BaseContent
	{
		public var demonScene:DemonScene = new DemonScene();
		public var demonSoldierScene:DemonSoldierScene = new DemonSoldierScene();
		
		public function DefiledRavine() {
			onGameInit(init);
		}

		private var _defiledRavineEncounter:GroupEncounter = null;
		public function get defiledRavineEncounter():GroupEncounter {
			return _defiledRavineEncounter;
		}

		private function init():void {
			_defiledRavineEncounter = Encounters.group("defiledravine", {
				name: "gunparts",
				when: function ():Boolean {
					return player.hasStatusEffect(StatusEffects.TelAdreTripxiGuns2) && player.statusEffectv2(StatusEffects.TelAdreTripxiGuns2) == 0 && player.hasKeyItem("Twin Dart pistol") < 0
				},
				chance: 30,
				call: partsofTwinDartPistol
			}, {
				name: "alvina1",
				when: function ():Boolean {
					return flags[kFLAGS.ALVINA_FOLLOWER] < 12 && player.hasKeyItem("Zetaz's Map") >= 0 && ((rand(10) == 0) || (flags[kFLAGS.LETHICE_DEFEATED] > 0))
				},
				call: SceneLib.alvinaFollower.alvinaThirdEncounter
			}, {
				name: "alvina2",
				when: function ():Boolean {
					return ((flags[kFLAGS.ALVINA_FOLLOWER] > 8 && flags[kFLAGS.ALVINA_FOLLOWER] < 12 && player.hasKeyItem("Zetaz's Map") >= 0) || (player.statusEffectv1(StatusEffects.SiegweirdTraining2) == 2) || SceneLib.alvinaFollower.SecondDateSuccess) && !SceneLib.alvinaFollower.AlvinaDied && !SceneLib.alvinaFollower.AlvinaPurified
				},
				call: SceneLib.alvinaFollower.alvinaThirdEncounter
			}, {
				name: "cowsuccubus",
				call: demonScene.CowSuccubusEncounter
			}, {
				name: "minoincubus",
				call: demonScene.MinoIncubusEncounter
			}, {
				name: "mine",
				when: function ():Boolean {
					return player.hasKeyItem("Old Pickaxe") > 0 && Forgefather.materialsExplained
				},
				call: mineRavine
			}, {
				name: "fleshgolems",
				call: SceneLib.fleshGolemScenes.introCorruptedImprovedFleshGolemS
			}, {
				name: "findimpfood",
				call: findImpFood
			}, {
				name: "demonsoldier",
				call: demonSoldierScene.encounterTheSoldierz
			}, {
				name: "nothing",
				call: findNothing
			}/*, {
				name: "demonProjects",
				chance: 0.2,
				when: function ():Boolean {
					return DemonLab.MainAreaComplete >= 4;
				},
				call: SceneLib.exploration.demonLabProjectEncounters
			}*/);
		}
		
		public function exploreDefiledRavine():void {
			clearOutput();
			flags[kFLAGS.DISCOVERED_DEFILED_RAVINE]++;
			if (player.cor < 71) dynStats("cor", 1.5);
			doNext(camp.returnToCampUseOneHour);
			defiledRavineEncounter.execEncounter();
			flushOutputTextToGUI();
		}

		private function findNothing():void {
			clearOutput();
			outputText("You spend one hour exploring the tainted ravine but you don't manage to find anything interesting, unless feeling like you are becoming slightly more horny counts.");
			dynStats("lib", 1);
			doNext(camp.returnToCampUseOneHour);
		}

		private function findImpFood():void {
			clearOutput();
			outputText("You spot something on the ground. Taking a closer look, it's one of those imps food packages. ");
			inventory.takeItem(consumables.IMPFOOD, camp.returnToCampUseOneHour);
		}

		private function mineRavine():void {
			clearOutput();
			outputText("You stumble across a vein of Marble, this looks like suitable material for your gargoyle form.\n");
			outputText("Do you wish to mine it?");
			menu();
			addButton(0, "Yes", defiledRavineSiteMine);
			addButton(1, "No", camp.returnToCampUseOneHour);
		}

		public function partsofTwinDartPistol():void {
			clearOutput();
			outputText("As you explore the blight ridge you run into what appears to be the half buried remains of some old contraption. Wait this might just be what that gun vendor was talking about! You proceed to dig up the items releasing this to indeed be the remains of a broken firearm.\n\n");
			outputText("You carefully put the pieces of the Twin Dart pistol in your back and head back to your camp.\n\n");
			player.addStatusValue(StatusEffects.TelAdreTripxi, 2, 1);
			player.createKeyItem("Twin Dart pistol", 0, 0, 0, 0);
			doNext(camp.returnToCampUseOneHour);
		}

		private function defiledRavineSiteMine():void {
			if (Forgefather.materialsExplained != 1) doNext(camp.returnToCampUseOneHour);
			else {
				clearOutput();
				if (player.fatigue > player.maxFatigue() - 50) {
					outputText("\n\n<b>You are too tired to consider mining. Perhaps some rest will suffice?</b>");
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				outputText("\n\nYou begin slamming your pickaxe against the marble, spending the better part of the next two hours mining. This done, you bring back your prize to camp. ");
				var minedStones:Number = 13 + Math.floor(player.str / 20);
				minedStones = Math.round(minedStones);
				fatigue(50, USEFATG_PHYSICAL);
				SceneLib.forgefatherScene.incrementMarbleSupply(minedStones);
				player.mineXP(1);
				findGem();
				doNext(camp.returnToCampUseTwoHours);
			}
		}

		private function findGem():void {
			if (player.miningLevel > 4) {
				if (rand(4) == 0) {
					inventory.takeItem(useables.TPAZGEM, camp.returnToCampUseTwoHours);
					player.mineXP(2);
				}
				else {
					outputText("After attempt to mine Topaz you ended with unusable piece.");
					doNext(camp.returnToCampUseTwoHours);
				}
			}
			else {
				outputText(" Your mining skill is too low to find any Topaz.");
				doNext(camp.returnToCampUseTwoHours);
			}
		}

	}
}