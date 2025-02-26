﻿/**
 * Created by aimozg on 05.01.14.
 */
package classes.Scenes
{
import classes.*;
import classes.BodyParts.LowerBody;
import classes.GlobalFlags.kFLAGS;
import classes.Scenes.Areas.DeepSea.Kraken;
import classes.Scenes.Areas.Forest.AlrauneMaiden;
import classes.Scenes.Areas.Forest.WapsHuntress;
import classes.Scenes.Areas.Forest.WaspAssassin;
import classes.Scenes.Areas.Forest.WaspGirl;
import classes.Scenes.Areas.Ocean.Scylla;
import classes.Scenes.Dungeons.DemonLab.ProjectFlameSpreader;
import classes.Scenes.Dungeons.DemonLab.ProjectNightwalker;
import classes.Scenes.Dungeons.DemonLab.ProjectTyrant;
import classes.Scenes.Dungeons.DemonLab.UltimisFlamespreader;
import classes.Scenes.Dungeons.HiddenCave;
import classes.Scenes.Explore.*;
import classes.Scenes.Monsters.*;
import classes.Scenes.NPCs.EvangelineFollower;
import classes.Scenes.NPCs.KihaFollower;
import classes.Scenes.NPCs.RyuBiDragon;
import classes.Scenes.Places.TrollVillage;
import classes.display.SpriteDb;

import coc.view.ButtonDataList;

//import classes.Scenes.Areas.nazwa lokacji;
	//import classes.Scenes.Areas.nazwa lokacji;
public class Exploration extends BaseContent
	{
		public var exploreDebug:ExploreDebug = new ExploreDebug();
		public var hiddencave:HiddenCave = new HiddenCave();

		public function Exploration()
		{
		}

		public function furriteMod():Number {
			return furriteFnGen()();
		}

		public function lethiteMod():Number {
			return lethiteFnGen()();
		}

		// Why? Because what if you want to alter the iftrue/iffalse?
		// Default values: mods:[SceneLib.exploration.furriteMod]
		// Non-default:    mods:[SceneLib.exploration.furriteFnGen(4,0)]

		public function furriteFnGen(iftrue:Number = 3, iffalse:Number = 1):Function {
			return function ():Number {
				return player.hasPerk(PerkLib.PiercedFurrite) ? iftrue : iffalse;
			}
		}

		public function lethiteFnGen(iftrue:Number = 3, iffalse:Number = 1):Function {
			return function ():Number {
				return player.hasPerk(PerkLib.PiercedLethite) ? iftrue : iffalse;
			}
		}
		//const MET_OTTERGIRL:int = 777;
		//const HAS_SEEN_MINO_AND_COWGIRL:int = 892;
		//const EXPLORATION_PAGE:int = 1015;
		//const BOG_EXPLORED:int = 1016;
		public function doExplore():void {
			clearOutput();
			if (player.explored <= 0) {
				outputText("You tentatively step away from your campsite, alert and scanning the ground and sky for danger.  You walk for the better part of an hour, marking the rocks you pass for a return trip to your camp.  It worries you that the portal has an opening on this side, and it was totally unguarded...\n\n...Wait a second, why is your campsite in front of you? The portal's glow is clearly visible from inside the tall rock formation. Even the warning sign about the cursed site or worn down training dummy you found when looking around camp earlier are here. Looking carefully, you see your footprints leaving the opposite side of your camp, then disappearing. You look back the way you came and see your markings vanish before your eyes. ");
				outputText("The implications boggle your mind as you do your best to mull over them. Distance, direction, and geography seem to have little meaning here, yet your campsite remains exactly as you left it. A few things click into place as you realize you found your way back just as you were mentally picturing the portal! Perhaps memory influences travel here, just like time, distance, and speed would in the real world!\n\nThis won't help at all with finding new places, but at least you can get back to camp quickly. You are determined to stay focused the next time you explore and learn how to traverse this gods-forsaken realm.");
				player.createStatusEffect(StatusEffects.EzekielCurse, 0, 0, 0, 0);
				tryDiscover();
				return;
			} else if (player.explored == 1) {
				outputText("You walk for quite some time, roaming the hard-packed and pink-tinged earth of the demon-realm.  Rust-red rocks speckle the wasteland, as barren and lifeless as anywhere else you've been.  A cool breeze suddenly brushes against your face, as if gracing you with its presence.  You turn towards it and are confronted by the lush foliage of a very old-looking forest.  You smile as the plants look fairly familiar and non-threatening.  Unbidden, you remember your decision to test the properties of this place, and think of your campsite as you walk forward.  Reality seems to shift and blur, making you dizzy, but after a few minutes you're back, and sure you'll be able to return to the forest with similar speed.\n\n<b>You have discovered the Forest!</b>");
				tryDiscover();
				player.exploredForest++;
				return;
			} else if (player.explored > 1) outputText("You can continue to search for new locations, or explore your previously discovered locations.\n");

			if (flags[kFLAGS.EXPLORE_MENU_STYLE] == 1) {
				oldExploreMenu();
				return;
			}
			
			hideMenus();
			menu();
			var bd:ButtonDataList = new ButtonDataList();
			// Row 1
			bd.add("Forest (O)", SceneLib.forest.exploreForestOutskirts)
					.hint("Visit the lush forest. "
							+ (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExplored() : ""))
					.disableIf(!SceneLib.forest.isDiscovered(), "You need to 'Explore' Mareth more.");
			bd.add("Forest (I)", SceneLib.forest.exploreForest)
					.hint("Visit the lush forest. "
							+ (player.level < 12 ? "\n\nBeware of Tentacle Beasts!" : "")
							+ (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExplored() : ""))
					.disableIf(!(SceneLib.forest.isDiscovered() && player.level >= 3), "You need to be ready (lvl 3+) to reach this area.");
			bd.add("Deepwoods", SceneLib.forest.exploreDeepwoods)
					.hint("Visit the dark, bioluminescent deepwoods. "
							+ (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExploredDeepwoods() : ""))
					.disableIf(!SceneLib.forest.deepwoodsDiscovered(), "Discovered when exploring Forest (I).");
			bd.add("");
			bd.add("");
			// Row 2
			bd.add("Lake", SceneLib.lake.exploreLake)
					.hint("Visit the lake and explore the beach. "
							+ (player.level < 3 ? "\n\nLooks like it's still quiet here!" : "")
							+ (debug ? "\n\nTimes explored: " + player.exploredLake : ""))
					.disableIf(player.exploredLake == 0, "You need to 'Explore' Mareth more.")
			bd.add("Boat", SceneLib.boat.boatExplore)
					.hint("Get on the boat and explore the lake. \n\nRecommended level: 12")
					.disableIf(!player.hasStatusEffect(StatusEffects.BoatDiscovery), "Search the lake.");
			//bd.add("Shore").hint("TBA"); //Discovered when exploring using Lake Boat.
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 3
			bd.add("Desert (O)", SceneLib.desert.exploreDesert)
					.hint("Visit the dry desert (outer part). "
							+ (debug ? "\n\nTimes explored: " + player.exploredDesert : ""))
					.disableIf(player.exploredDesert == 0, "You need to 'Explore' Mareth more.");
			bd.add("Desert (I)", SceneLib.desert.exploreInnerDesert)
					.hint("Visit the dry desert (inner part). "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_INNER_DESERT] : ""))
					.disableIf(flags[kFLAGS.DISCOVERED_INNER_DESERT] == 0, "Discovered when exploring Desert (Outer).");
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 4
			bd.add("Battlefield (B)", SceneLib.battlefiledboundary.exploreBattlefieldBoundary)
					.hint("Visit the battlefield boundary. "
							+ (player.level < 16 ? "\n\nIt's still too dangerous place to visit lightly!" : "")
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] : ""))
					.disableIf(flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] == 0, "Discovered when using 'Explore' after finding Desert (Outer).");
			bd.add("Battlefield (O)", SceneLib.battlefiledouter.exploreOuterBattlefield)
					.hint("Visit the outer battlefield. "
							+ (player.level < 18 ? "\n\nIt's still too dangerous place to visit lightly!" : "")
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_OUTER_BATTLEFIELD] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_OUTER_BATTLEFIELD], "Discovered when exploring Battlefield (Boundary).");
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 5
			bd.add("Hills", SceneLib.mountain.exploreHills)
					.hint("Visit the hills. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_HILLS] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_HILLS], "Discovered when using 'Explore' after finding Battlefield (Boundary).");
			bd.add("Low Mountain", SceneLib.mountain.exploreLowMountain)
					.hint("Visit the low mountains. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_LOW_MOUNTAIN] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_LOW_MOUNTAIN], "Discovered when exploring Hills.");
			bd.add("Mountain", SceneLib.mountain.exploreMountain)
					.hint("Visit the mountain. "
							+ (debug ? "\n\nTimes explored: " + player.exploredMountain : ""))
					.disableIf(player.exploredMountain == 0, "Discovered when exploring Low Mountains.");
			bd.add("High Mountain", SceneLib.highMountains.exploreHighMountain)
					.hint("Visit the high mountains where basilisks and harpies are found. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN], "Discovered when exploring Mountain.");
			bd.add("");
			// Row 6
			bd.add("Plains", SceneLib.plains.explorePlains)
					.hint("Visit the plains. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.TIMES_EXPLORED_PLAINS] : ""))
					.disableIf(flags[kFLAGS.TIMES_EXPLORED_PLAINS] == 0, "Discovered when using 'Explore' after finding Hills.");
			bd.add(""); // plains inner part
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 7
			bd.add("Swamp", SceneLib.swamp.exploreSwamp)
					.hint("Visit the wet swamplands. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.TIMES_EXPLORED_SWAMP] : ""))
					.disableIf(flags[kFLAGS.TIMES_EXPLORED_SWAMP] == 0, "Discovered when using 'Explore' after finding Plains.");
			bd.add("Bog", SceneLib.bog.exploreBog)
					.hint("Visit the dark bog. \n\nRecommended level: 28"
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.BOG_EXPLORED] : ""))
					.disableIf(!flags[kFLAGS.BOG_EXPLORED], "Discovered when exploring Swamp.");
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 8
			bd.add("Blight Ridge", SceneLib.blightridge.exploreBlightRidge)
					.hint("Visit the corrupted blight ridge. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE], "Discovered when using 'Explore' after finding Swamp.");
			bd.add("Defiled Ravine", SceneLib.defiledravine.exploreDefiledRavine)
					.hint("Visit the defiled ravine. \n\nRecommended level: 41"
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_DEFILED_RAVINE] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_DEFILED_RAVINE], "Discovered when exploring Blight Ridge.");
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 9
			bd.add("Beach", SceneLib.beach.exploreBeach)
					.hint("Visit the sunny beach. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BEACH] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_BEACH], "Discovered when using 'Explore' after finding Blight Ridge.");
			bd.add("Ocean", SceneLib.ocean.exploreOcean)
					.hint("Explore the ocean surface. But beware of... sharks. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_OCEAN] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_OCEAN], "You need to find first some way to sail over the water surface to explore this area.")
					.disableIf(!flags[kFLAGS.DISCOVERED_BEACH], "Need to find Beach first and then finding some way to sail on the water.");
			bd.add(""); // Deep Sea
			// if (flags[kFLAGS.DISCOVERED_DEEP_SEA] > 0 && player.canSwimUnderwater()) addButton(2, "Deep Sea", SceneLib.deepsea.exploreDeepSea).hint("Visit the 'almost virgin' deep sea. But beware of... krakens. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_DEEP_SEA] : ""));
			bd.add("");
			bd.add("");
			// Row 10
			bd.add("Caves", SceneLib.caves.exploreCaves)
					.hint("Visit the gloomy caves. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_CAVES] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_CAVES], "Discovered when using 'Explore' after finding Beach.")
			bd.add("");
			bd.add("");
			bd.add("");
			bd.add("");
			// Row 11
			bd.add("");
			bd.add("Tundra", SceneLib.tundra.exploreTundra)
					.hint("Visit the tundra. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_TUNDRA] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_TUNDRA], "Discovered when exploring Caves.");
			bd.add("Glacial Rift(O)", SceneLib.glacialRift.exploreGlacialRift)
					.hint("Visit the chilly glacial rift (outer part). "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_GLACIAL_RIFT] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_GLACIAL_RIFT], "Discovered when exploring Tundra.");
			bd.add("");
			bd.add("");
			// Row 12
			bd.add("");
			bd.add("Ashlands", SceneLib.ashlands.exploreAshlands)
					.hint("Visit the ashlands. "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_ASHLANDS] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_ASHLANDS], "Discovered when exploring Caves.");
			bd.add("VolcanicCrag(O)", SceneLib.volcanicCrag.exploreVolcanicCrag)
					.hint("Visit the infernal volcanic crag (outer part). "
							+ (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_VOLCANO_CRAG] : ""))
					.disableIf(!flags[kFLAGS.DISCOVERED_VOLCANO_CRAG], "Discovered when exploring Ashlands.");
			bd.add("");
			bd.add("");
			
			//if (flags[kFLAGS.DISCOVERED_] > 0) addButton(5, "",	//Wuxia related area - ?latająca wyspa?
			//if (flags[kFLAGS.DISCOVERED_] > 0) addButton(9, "",	//Wuxia related area - ?latająca wyspa?
			//if (flags[kFLAGS.DISCOVERED_PIT] > 0) addButton(10, "Pit", CoC.instance.abyss.explorePit).hint("Visit the pit. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_PIT] : ""));
			//if (flags[kFLAGS.DISCOVERED_ABYSS] > 0) addButton(12, "Abyss", CoC.instance.abyss.exploreAbyss).hint("Visit the abyss. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_ABYSS] : ""));
			
			
			bigButtonGrid(bd);
			addButton(0, "Explore", tryDiscover)
					.hint("Explore to find new regions and visit any discovered regions.");
			addButton(4, "Menu Style", toggleMenuStyle)
					.hint("Switch to old menu style");
			addButton(5, "LL Explore", tryDiscoverLL)
					.hint("Explore to find weakest new enemies.")
					.disableIf(player.level < 31,"Req. lvl 31+");
			addButton(6, "ML Explore", tryDiscoverML)
					.hint("Explore to find weaker new enemies.")
					.disableIf(player.level < 51,"Req. lvl 51+");
			addButton(7, "HL Explore", tryDiscoverHL)
					.hint("Explore to find below averange new enemies.")
					.disableIf(player.level < 70,"Req. lvl 70+");
			addButton(8, "XHL Explore", tryDiscoverXHL)
					.hint("Explore to find bit above averange new enemies.")
					.disableIf(player.level < 95,"Req. lvl 95+");
			addButton(9, "XXHL Explore", tryDiscoverXXHL)
					.hint("Explore to find strong new enemies.")
					.disableIf(player.level < 125,"Req. lvl 125+");
			addButton(12, "42", tryRNGod)
					.hint("Explore to find the answer for your prayers. Or maybe you really not wanna find it, fearing answer will not be happy with you?")
					.disableIf(!silly(), "Only in Silly Mode...", "???");
			if (debug) addButton(13, "Debug", exploreDebug.doExploreDebug);
			addButton(14, "Back", playerMenu);
		}
		
		private function toggleMenuStyle():void {
			flags[kFLAGS.EXPLORE_MENU_STYLE] = 1 - flags[kFLAGS.EXPLORE_MENU_STYLE];
			doExplore();
		}
		
		private function oldExploreMenu():void {
			if (flags[kFLAGS.EXPLORATION_PAGE] == 2) {
				explorePageII();
				return;
			}
			if (flags[kFLAGS.EXPLORATION_PAGE] == 3) {
				explorePageIII();
				return;
			}
			if (flags[kFLAGS.EXPLORATION_PAGE] == 4) {
				explorePageIV();
				return;
			}
			if (flags[kFLAGS.EXPLORATION_PAGE] == 5) {
				explorePageV();
				return;
			}
			hideMenus();
			menu();
			addButton(0, "Explore", tryDiscover).hint("Explore to find new regions and visit any discovered regions.");
			if (SceneLib.forest.isDiscovered()) addButton(1, "Forest (O)", SceneLib.forest.exploreForestOutskirts).hint("Visit the lush forest. " + (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExplored() : ""));
			if (player.exploredLake > 0) addButton(2, "Lake", SceneLib.lake.exploreLake).hint("Visit the lake and explore the beach. " + (player.level < 3 ? "\n\nLooks like it's still quiet here!" : "") + (debug ? "\n\nTimes explored: " + player.exploredLake : ""));
			else addButtonDisabled(2, "Lake", "You need to 'Explore' Mareth more.");
			if (player.exploredDesert > 0) addButton(3, "Desert (O)", SceneLib.desert.exploreDesert).hint("Visit the dry desert (outer part). " + (debug ? "\n\nTimes explored: " + player.exploredDesert : ""));
			else addButtonDisabled(3, "Desert", "You need to 'Explore' Mareth more.");
			
			if (flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] > 0) addButton(5, "Battlefield (B)", SceneLib.battlefiledboundary.exploreBattlefieldBoundary).hint("Visit the battlefield boundary. " + (player.level < 16 ? "\n\nIt's still too dangerous place to visit lightly!" : "") + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] : ""));
			else addButtonDisabled(5, "Battlefield (B)", "Discovered when using 'Explore' after finding Desert (Outer).");
			if (flags[kFLAGS.DISCOVERED_HILLS] > 0) addButton(6, "Hills", SceneLib.mountain.exploreHills).hint("Visit the hills. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_HILLS] : ""));
			else addButtonDisabled(6, "Hills", "Discovered when using 'Explore' after finding Battlefield (Boundary).");
			if (flags[kFLAGS.TIMES_EXPLORED_PLAINS] > 0) addButton(7, "Plains", SceneLib.plains.explorePlains).hint("Visit the plains. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.TIMES_EXPLORED_PLAINS] : ""));
			else addButtonDisabled(7, "Plains", "Discovered when using 'Explore' after finding Hills.");
			if (flags[kFLAGS.TIMES_EXPLORED_SWAMP] > 0) addButton(8, "Swamp", SceneLib.swamp.exploreSwamp).hint("Visit the wet swamplands. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.TIMES_EXPLORED_SWAMP] : ""));
			else addButtonDisabled(8, "Swamp", "Discovered when using 'Explore' after finding Plains.");
			
			if (flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] > 0) addButton(10, "Blight Ridge", SceneLib.blightridge.exploreBlightRidge).hint("Visit the corrupted blight ridge. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] : ""));
			else addButtonDisabled(10, "Blight Ridge", "Discovered when using 'Explore' after finding Swamp.");
			if (flags[kFLAGS.DISCOVERED_BEACH] > 0) addButton(11, "Beach", SceneLib.beach.exploreBeach).hint("Visit the sunny beach. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_BEACH] : ""));
			else addButtonDisabled(11, "Beach", "Discovered when using 'Explore' after finding Blight Ridge.");
			if (flags[kFLAGS.DISCOVERED_CAVES] > 0) addButton(12, "Caves", SceneLib.caves.exploreCaves).hint("Visit the gloomy caves. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_CAVES] : ""));
			else addButtonDisabled(12, "Caves", "Discovered when using 'Explore' after finding Beach.");
			
			addButton(4, "Next", explorePageII);
			if (debug) addButton(9, "Debug", exploreDebug.doExploreDebug);
			else addButton(9, "Menu Style", toggleMenuStyle).hint("Switch to new menu style");
			
			addButton(14, "Back", playerMenu);
		}
		
		private function explorePageII():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 2;
			hideMenus();
			menu();
			if (flags[kFLAGS.DISCOVERED_OUTER_BATTLEFIELD] > 0) addButton(0, "Battlefield(O)", SceneLib.battlefiledouter.exploreOuterBattlefield).hint("Visit the outer battlefield. " + (player.level < 18 ? "\n\nIt's still too dangerous place to visit lightly!" : "") + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_OUTER_BATTLEFIELD] : ""));
			else addButtonDisabled(0, "Battlefield(O)", "Discovered when exploring Battlefield (Boundary).");
			if (SceneLib.forest.isDiscovered() && player.level >= 3) addButton(1, "Forest (I)", SceneLib.forest.exploreForest).hint("Visit the lush forest. " + (player.level < 12 ? "\n\nBeware of Tentacle Beasts!" : "") + (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExplored() : ""));
			else addButtonDisabled(1, "Forest(I)", "You need to be ready (lvl 3+) to reach this area.");
			if (player.hasStatusEffect(StatusEffects.BoatDiscovery)) addButton(2, "Boat", SceneLib.boat.boatExplore).hint("Get on the boat and explore the lake. \n\nRecommended level: 12");
			else addButtonDisabled(2, "???", "Search the lake.");
			if (flags[kFLAGS.DISCOVERED_INNER_DESERT] > 0) addButton(3, "Desert (I)", SceneLib.desert.exploreInnerDesert).hint("Visit the dry desert (inner part). " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_INNER_DESERT] : ""));
			else addButtonDisabled(3, "Desert (I)", "Discovered when exploring Desert (Outer).");
			
			if (flags[kFLAGS.DISCOVERED_DEFILED_RAVINE] > 0) addButton(5, "Defiled Ravine", SceneLib.defiledravine.exploreDefiledRavine).hint("Visit the defiled ravine. \n\nRecommended level: 41" + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_DEFILED_RAVINE] : ""));
			else addButtonDisabled(5, "Defiled Ravine", "Discovered when exploring Blight Ridge.");
			if (flags[kFLAGS.DISCOVERED_LOW_MOUNTAIN] > 0) addButton(6, "Low Mountain", SceneLib.mountain.exploreLowMountain).hint("Visit the low mountains. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_LOW_MOUNTAIN] : ""));
			else addButtonDisabled(6, "Low Mountain", "Discovered when exploring Hills.");
			// 7 - plains inner part
			if (flags[kFLAGS.BOG_EXPLORED] > 0) addButton(8, "Bog", SceneLib.bog.exploreBog).hint("Visit the dark bog. \n\nRecommended level: 28" + (debug ? "\n\nTimes explored: " + flags[kFLAGS.BOG_EXPLORED] : ""));
			else addButtonDisabled(8, "Bog", "Discovered when exploring Swamp.");
			
			if (flags[kFLAGS.DISCOVERED_TUNDRA] > 0) addButton(10, "Tundra", SceneLib.tundra.exploreTundra).hint("Visit the tundra. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_TUNDRA] : ""));
			else addButtonDisabled(10, "Tundra", "Discovered when exploring Caves.");
			if (flags[kFLAGS.DISCOVERED_ASHLANDS] > 0) addButton(11, "Ashlands", SceneLib.ashlands.exploreAshlands).hint("Visit the ashlands. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_ASHLANDS] : ""));
			else addButtonDisabled(11, "Ashlands", "Discovered when exploring Caves.");
			//12 - darkness area
			//13 - lightning area
			
			addButton(4, "Next", explorePageIII);
			addButton(9, "Previous", goBackToPageI);
			if (debug) addButton(13, "Debug", exploreDebug.doExploreDebug);
			addButton(14, "Back", playerMenu);
		}
		
		private function explorePageIII():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 3;
			hideMenus();
			menu();
			// 0 - battlefield inner part
			if (SceneLib.forest.deepwoodsDiscovered()) addButton(1, "Deepwoods", SceneLib.forest.exploreDeepwoods).hint("Visit the dark, bioluminescent deepwoods. " + (debug ? "\n\nTimes explored: " + SceneLib.forest.timesExploredDeepwoods() : ""));
			else addButtonDisabled(1, "Deepwoods", "Discovered when exploring Forest (I).");
			//addButtonDisabled(2, "Shore", "TBA");//Discovered when exploring using Lake Boat.
			
			//if (flags[kFLAGS.DISCOVERED_] > 0) addButton(5, "",	//Wuxia related area - ?latająca wyspa?
			//if (flags[kFLAGS.DISCOVERED_] > 0) addButton(9, "",	//Wuxia related area - ?latająca wyspa?
			//if (flags[kFLAGS.DISCOVERED_PIT] > 0) addButton(5, "Pit", CoC.instance.abyss.explorePit).hint("Visit the pit. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_PIT] : ""));
			//if (flags[kFLAGS.DISCOVERED_ABYSS] > 0) addButton(5, "Abyss", CoC.instance.abyss.exploreAbyss).hint("Visit the abyss. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_ABYSS] : ""));
			if (player.exploredMountain > 0) addButton(6, "Mountain", SceneLib.mountain.exploreMountain).hint("Visit the mountain. " + (debug ? "\n\nTimes explored: " + player.exploredMountain : ""));
			else addButtonDisabled(6, "Mountain", "Discovered when exploring Low .");
			if (flags[kFLAGS.DISCOVERED_BEACH] > 0) {
				if (flags[kFLAGS.DISCOVERED_OCEAN] > 0) addButton(8, "Ocean", SceneLib.ocean.exploreOcean).hint("Explore the ocean surface. But beware of... sharks. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_OCEAN] : ""));
				else addButtonDisabled(8, "Ocean", "You need to find first some way to sail over the water surface to explore this area.");
			} else addButtonDisabled(8, "Ocean", "Need to find Beach first and then finding some way to sail on the water.");
			
			if (flags[kFLAGS.DISCOVERED_GLACIAL_RIFT] > 0) addButton(10, "Glacial Rift(O)", SceneLib.glacialRift.exploreGlacialRift).hint("Visit the chilly glacial rift (outer part). " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_GLACIAL_RIFT] : ""));
			else addButtonDisabled(10, "Glacial Rift(O)", "Discovered when exploring Tundra.");
			if (flags[kFLAGS.DISCOVERED_VOLCANO_CRAG] > 0) addButton(11, "Volcanic Crag(O)", SceneLib.volcanicCrag.exploreVolcanicCrag).hint("Visit the infernal volcanic crag (outer part). " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_VOLCANO_CRAG] : ""));
			else addButtonDisabled(11, "Volcanic Crag(O)", "Discovered when exploring Ashlands.");
			
			addButton(4, "Next", goBackToPageIV);
			addButton(9, "Previous", goBackToPageII);
			if (debug) addButton(13, "Debug", exploreDebug.doExploreDebug);
			addButton(14, "Back", playerMenu);
		}
		
		private function explorePageIV():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 4;
			hideMenus();
			menu();
			if (flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN] > 0) addButton(6, "High Mountain", SceneLib.highMountains.exploreHighMountain).hint("Visit the high mountains where basilisks and harpies are found. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_HIGH_MOUNTAIN] : ""));
			else addButtonDisabled(6, "High Mountain", "Discovered when exploring Mountain.");
			//if (flags[kFLAGS.DISCOVERED_DEEP_SEA] > 0 && player.canSwimUnderwater()) addButton(8, "Deep Sea", SceneLib.deepsea.exploreDeepSea).hint("Visit the 'almost virgin' deep sea. But beware of... krakens. " + (debug ? "\n\nTimes explored: " + flags[kFLAGS.DISCOVERED_DEEP_SEA] : ""));
			
			addButton(4, "Next", goBackToPageV);
			addButton(9, "Previous", goBackToPageIII);
			if (debug) addButton(13, "Debug", exploreDebug.doExploreDebug);
			addButton(14, "Back", playerMenu);
		}
		
		private function explorePageV():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 5;
			hideMenus();
			menu();
			if (player.level >= 31) addButton(0, "LL Explore", tryDiscoverLL).hint("Explore to find weakest new enemies.");
			else addButtonDisabled(0, "LL Explore", "Req. lvl 31+");
			if (player.level >= 51) addButton(1, "ML Explore", tryDiscoverML).hint("Explore to find weaker new enemies.");
			else addButtonDisabled(1, "ML Explore", "Req. lvl 51+");
			if (player.level >= 70) addButton(2, "HL Explore", tryDiscoverHL).hint("Explore to find below averange new enemies.");
			else addButtonDisabled(2, "HL Explore", "Req. lvl 70+");
			if (player.level >= 95) addButton(3, "XHL Explore", tryDiscoverXHL).hint("Explore to find bit above averange new enemies.");
			else addButtonDisabled(3, "XHL Explore", "Req. lvl 95+");
			if (player.level >= 125) addButton(4, "XXHL Explore", tryDiscoverXXHL).hint("Explore to find strong new enemies.");
			else addButtonDisabled(4, "XXHL Explore", "Req. lvl 125+");
			
			addButton(9, "Previous", goBackToPageIV);
			if (silly()) addButton(12, "42", tryRNGod).hint("Explore to find the answer for your prayers. Or maybe you really not wanna find it fearing answer will not be happy with you?");
			else addButtonDisabled(12, "???", "Only in Silly Mode...");
			if (debug) addButton(13, "Debug", exploreDebug.doExploreDebug);
			addButton(14, "Back", playerMenu);
		}
		
		private function goBackToPageI():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 1;
			doExplore();
		}
		
		private function goBackToPageII():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 2;
			doExplore();
		}
		
		private function goBackToPageIII():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 3;
			doExplore();
		}
		
		private function goBackToPageIV():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 4;
			doExplore();
		}
		
		private function goBackToPageV():void {
			flags[kFLAGS.EXPLORATION_PAGE] = 5;
			doExplore();
		}

		public function genericGolGobImpEncounters(even:Boolean = false):void {
			var impGobGol:Number = 5;
			if (!even) {
				if (player.cockTotal() > 0) impGobGol--;
				if (player.hasVagina()) impGobGol++;
				if (player.totalFertility() >= 30) impGobGol++;
				if (player.cumQ() >= 200) impGobGol--;
				if (player.hasPerk(PerkLib.PiercedLethite)) {
					if (impGobGol <= 3) impGobGol += 2;
					else if (impGobGol < 7) impGobGol = 7;
				}
			}
			//Imptacular Encounter
			if (rand(10) < impGobGol) {
				var impChooser:int = rand(100);
				//Level modifier
				if (player.level < 20) impChooser += player.level;
				else impChooser += 20;
				//Limit chooser ranges
				if (impChooser > 100) impChooser = 100;
				if (player.level < 8 && impChooser >= 40) impChooser = 39;
				else if (player.level < 12 && impChooser >= 60) impChooser = 59;
				else if (player.level < 16 && impChooser >= 80) impChooser = 79;
				//Imp Lord
				if (impChooser >= 50 && impChooser < 70) {
					if (flags[kFLAGS.GALIA_LVL_UP] > 0 && flags[kFLAGS.GALIA_LVL_UP] < 0.5) {
						if (rand(4) == 0) SceneLib.impScene.impLordEncounter();
						else SceneLib.impScene.impLordFeralEncounter();
					}
					else {
						if (rand(4) == 0) SceneLib.impScene.impLordFeralEncounter();
						else SceneLib.impScene.impLordEncounter();
					}
					spriteSelect(SpriteDb.s_imp);
					return;
				}
				//Imp Warlord
				else if (impChooser >= 70 && impChooser < 90) {
					if (flags[kFLAGS.GALIA_LVL_UP] > 0 && flags[kFLAGS.GALIA_LVL_UP] < 0.5) {
						if (rand(4) == 0) SceneLib.impScene.impWarlordEncounter();
						else SceneLib.impScene.impWarlordFeralEncounter();
					}
					else {
						if (rand(4) == 0) SceneLib.impScene.impWarlordFeralEncounter();
						else SceneLib.impScene.impWarlordEncounter();
					}
					spriteSelect(SpriteDb.s_impWarlord);
					return;
				}
				//Imp Overlord (Rare!)
				else if (impChooser >= 90) {
					SceneLib.impScene.impOverlordEncounter();
					spriteSelect(SpriteDb.s_impOverlord);
					return;
				}
				else {
					clearOutput();
					if (flags[kFLAGS.GALIA_LVL_UP] > 0 && flags[kFLAGS.GALIA_LVL_UP] < 0.5) {
						if (rand(4) == 0) {
							outputText("An imp wings out of the sky and attacks!");
							camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_IMPS);
							startCombat(new Imp());
						}
						else {
							outputText("A feral imp wings out of the sky and attacks!");
							camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_IMPS);
							flags[kFLAGS.FERAL_EXTRAS] = 1;
							startCombat(new FeralImps());
						}
					}
					else {
						if (rand(4) == 0 && (player.level >= 3 || player.statusEffectv2(StatusEffects.AdventureGuildQuests2) > 0)) {
							outputText("A feral imp wings out of the sky and attacks!");
							camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_IMPS);
							flags[kFLAGS.FERAL_EXTRAS] = 1;
							startCombat(new FeralImps());
						}
						else {
							outputText("An imp wings out of the sky and attacks!");
							camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_IMPS);
							startCombat(new Imp());
						}
					}
					spriteSelect(SpriteDb.s_imp);
				}
				return;
			}
			//Encounter Golemuuu!
			//Encounter Gobbalin!
			else {
				if (player.level >= 6 && rand(10) >= 7) {
					var golemChooser:int = rand(70);
					//Limit chooser range
					if (player.level < 12 && golemChooser >= 10) golemChooser = 9;
					else if (player.level < 18 && golemChooser >= 20) golemChooser = 19;
					else if (player.level < 24 && golemChooser >= 30) golemChooser = 29;
					else if (player.level < 33 && golemChooser >= 40) golemChooser = 39;
					else if (player.level < 42 && golemChooser >= 50) golemChooser = 49;
					else if (player.level < 51 && golemChooser >= 60) golemChooser = 59;
					clearOutput();
					//Improved dummy golem
					if (golemChooser >= 10 && golemChooser < 20) {
						outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered improved dummy golem! You ready your [weapon] for a fight!");
						startCombat(new GolemDummyImproved());
						return;
					}
					//Advanced dummy golem or golems
					if (golemChooser >= 20 && golemChooser < 30) {
						if (rand(4) == 0) {
							outputText("As you take a stroll, out of nearby bushes emerge group of golems. Looks like you have encountered advanced dummy golems! You ready your [weapon] for a fight!");
							startCombat(new GolemsDummyAdvanced());
							return;
						}
						else {
							outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered advanced dummy golem! You ready your [weapon] for a fight!");
							startCombat(new GolemDummyAdvanced());
							return;
						}
					}
					//Superior dummy golem or golems
					if (golemChooser >= 30 && golemChooser < 40) {
						if (rand(4) == 0) {
							outputText("As you take a stroll, out of nearby bushes emerge group of golems. Looks like you have encountered superior dummy golems! You ready your [weapon] for a fight!");
							startCombat(new GolemsDummySuperior());
							return;
						}
						else {
							outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered superior dummy golem! You ready your [weapon] for a fight!");
							startCombat(new GolemDummySuperior());
							return;
						}
					}
					//Basic true golem or golems
					if (golemChooser >= 40 && golemChooser < 50) {
						if (rand(4) == 0) {
							outputText("As you take a stroll, out of nearby bushes emerge group of golems. Looks like you have encountered basic true golems! You ready your [weapon] for a fight!");
							startCombat(new GolemsTrueBasic());
							return;
						}
						else {
							outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered basic true golem! You ready your [weapon] for a fight!");
							startCombat(new GolemTrueBasic());
							return;
						}
					}
					//Improved true golem or golems
					if (golemChooser >= 50 && golemChooser < 60) {
						if (rand(4) == 0) {
							outputText("As you take a stroll, out of nearby bushes emerge group of golems. Looks like you have encountered improved true golems! You ready your [weapon] for a fight!");
							startCombat(new GolemsTrueImproved());
							return;
						}
						else {
							outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered improved true golem! You ready your [weapon] for a fight!");
							startCombat(new GolemTrueImproved());
							return;
						}
					}
					//Advanced true golem or golems
					if (golemChooser >= 60) {
						if (rand(4) == 0) {
							outputText("As you take a stroll, out of nearby bushes emerge group of golems. Looks like you have encountered advanced true golems! You ready your [weapon] for a fight!");
							startCombat(new GolemsTrueAdvanced());
							return;
						}
						else {
							outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered advanced true golem! You ready your [weapon] for a fight!");
							startCombat(new GolemTrueAdvanced());
							return;
						}
					}
					//Dummy golem
					else {
						outputText("As you take a stroll, out of nearby bushes emerge golem. Looks like you have encountered dummy golem! You ready your [weapon] for a fight!");
						camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_GOLEMS);
						startCombat(new GolemDummy());
						return;
					}
				}
				else {
					var goblinChooser:int = rand(100);
					//Level modifier
					if (player.level < 20) goblinChooser += player.level;
					else goblinChooser += 20;
					//Limit chooser range
					if (goblinChooser > 100) goblinChooser = 100;
					if (player.level < 8 && goblinChooser >= 20) goblinChooser = 29;
					else if (player.level < 16 && goblinChooser >= 60) goblinChooser = 49;
					else if (player.level < 24 && goblinChooser >= 80) goblinChooser = 79;
					if (goblinChooser >= 30 && goblinChooser < 50) SceneLib.goblinScene.goblinAssassinEncounter();
					else if (goblinChooser >= 50 && goblinChooser < 75) SceneLib.goblinScene.goblinWarriorEncounter();
					else if (goblinChooser >= 75) {
						if (flags[kFLAGS.SOUL_SENSE_PRISCILLA] < 3 && rand(2) == 0) SceneLib.priscillaScene.goblinElderEncounter(); //not yet imported
						else SceneLib.goblinScene.goblinShamanEncounter();
					}
					else SceneLib.goblinScene.goblinEncounter();
				}
			}
		}
		public function genericGobImpAngEncounters(even:Boolean = false):void {
			var gobImpAngChooser:int = rand(20);
			if (gobImpAngChooser >= 8) SceneLib.goblinScene.goblinShamanEncounter();
			//else if (gobImpAngChooser >= 16) angeloid
			//else if (gobImpAngChooser >= 18) angeloid
			else {
				SceneLib.impScene.impOverlordEncounter();
				spriteSelect(SpriteDb.s_impOverlord);
			}
		}
		public function genericImpEncounters2(even:Boolean = false):void {
			//Imptacular Encounter
			var impChooser:int = rand(100);
			//Level modifier
			if (player.level < 20) impChooser += player.level;
			else impChooser += 20;
			//Limit chooser ranges
			if (impChooser > 100) impChooser = 100;
			if (player.level < 16 && impChooser >= 75) impChooser = 74;
			//Imp Warlord
			if (impChooser >= 50 && impChooser < 75) {
				if (rand(4) == 0) SceneLib.impScene.impWarlordFeralEncounter();
				else SceneLib.impScene.impWarlordEncounter();
				spriteSelect(SpriteDb.s_impWarlord);
				return;
			}
			//Imp Overlord
			else if (impChooser >= 75) {
				SceneLib.impScene.impOverlordEncounter();
				spriteSelect(SpriteDb.s_impOverlord);
				return;
			}
			//Pack of Imps
			else {
				if (rand(4) == 0) SceneLib.impScene.impPackEncounter2();
				else SceneLib.impScene.impPackEncounter();
				return;
			}
		}
		public function genericDemonsEncounters1(even:Boolean = false):void {
			//Imptacular Encounter
			var demonChooser:int = rand(15);
			//Succubus
			if (demonChooser >= 5 && demonChooser < 10) {
				SceneLib.defiledravine.demonScene.SuccubusEncounter();
				return;
			}
			//Incubus
			else if (demonChooser >= 10) {
				SceneLib.defiledravine.demonScene.IncubusEncounter();
				return;
			}
			//Omnibus
			else {
				SceneLib.defiledravine.demonScene.OmnibusEncounter();
				return;
			}
		}
		public function genericGolemsEncounters1(even:Boolean = false):void {
			var golemsChooser:int = rand(60);
			//Limit chooser range
			if (player.level < 12 && golemsChooser >= 10) golemsChooser = 9;
			else if (player.level < 18 && golemsChooser >= 20) golemsChooser = 19;
			else if (player.level < 24 && golemsChooser >= 30) golemsChooser = 29;
			else if (player.level < 33 && golemsChooser >= 40) golemsChooser = 39;
			clearOutput();
			//Improved dummy golems
			if (golemsChooser >= 10 && golemsChooser < 20) {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered improved dummy golems! You ready your [weapon] for a fight!");
				startCombat(new GolemsDummyImproved());
				return;
			}
			//Advanced dummy golems
			if (golemsChooser >= 20 && golemsChooser < 30) {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered advanced dummy golems! You ready your [weapon] for a fight!");
				startCombat(new GolemsDummyAdvanced());
				return;
			}
			//Superior dummy golems
			if (golemsChooser >= 30 && golemsChooser < 40) {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered superior dummy golems! You ready your [weapon] for a fight!");
				startCombat(new GolemsDummySuperior());
				return;
			}
			//Basic true golems
			if (golemsChooser >= 40 && golemsChooser < 50) {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered basic true golems! You ready your [weapon] for a fight!");
				startCombat(new GolemsTrueBasic());
				return;
			}
			//Improved true golems
			if (golemsChooser >= 50) {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered improved true golems! You ready your [weapon] for a fight!");
				startCombat(new GolemsTrueImproved());
				return;
			}
			//Dummy golems
			else {
				outputText("As you take a stroll, from behind of nearby combatants remains emerge group of golems. Looks like you have encountered dummy golems! You ready your [weapon] for a fight!");
				camp.codex.unlockEntry(kFLAGS.CODEX_ENTRY_GOLEMS);
				startCombat(new GolemsDummy());
				return;
			}
		}
		public function genericGobImpEncounters1(even:Boolean = false):void {
			var gobimpChooser:int = rand(40);
			//Limit chooser range
			if (player.level < 18 && gobimpChooser >= 20) gobimpChooser = 19;
			else if (player.level < 30 && gobimpChooser >= 30) gobimpChooser = 29;
			clearOutput();
			if (gobimpChooser >= 10 && gobimpChooser < 20) {
				if (rand(2) == 0) SceneLib.impScene.impPackEncounter2();
				else SceneLib.angelScene.angelGroupEncounter();
			}
			else if (gobimpChooser >= 20 && gobimpChooser < 30) {
				if (rand(2) == 0) SceneLib.impScene.impPackEncounter();
				else SceneLib.angelScene.angelGroupEncounter();
			}
			else if (gobimpChooser >= 30) {
				if (flags[kFLAGS.TIMES_ENCOUNTERED_GOBLIN_WARRIOR] >= 1) SceneLib.goblinScene.goblinWarriorsEncounter();
				else SceneLib.impScene.impPackEncounter();
			}
			else {
				if (flags[kFLAGS.TIMES_ENCOUNTERED_GOBLIN_ASSASSIN] >= 1) SceneLib.goblinScene.goblinAdventurersEncounter();
				else SceneLib.impScene.impPackEncounter2();
			}
		}
		public function genericAngelsEncounters(even:Boolean = false):void {
			var angelsChooser:int = rand(15);
			//Limit chooser range
			if (player.level < 6 && angelsChooser >= 5) angelsChooser = 4;
			else if (player.level < 12 && angelsChooser >= 10) angelsChooser = 9;
			clearOutput();
			//Mid-rank Angel
			if (angelsChooser >= 5 && angelsChooser < 10) {
				outputText("A mid-ranked angeloid wings out of the sky and attacks!");
				player.createStatusEffect(StatusEffects.AngelsChooser,2,0,0,0);
				startCombat(new Angeloid());
				return;
			}
			//High-rank Angel
			else if (angelsChooser >= 10) {
				outputText("A high-ranked angeloid wings out of the sky and attacks!");
				player.createStatusEffect(StatusEffects.AngelsChooser,3,0,0,0);
				startCombat(new Angeloid());
				return;
			}
			//Low-rank Angel
			else {
				outputText("A low-ranked angeloid wings out of the sky and attacks!");
				player.createStatusEffect(StatusEffects.AngelsChooser,1,0,0,0);
				startCombat(new Angeloid());
				return;
			}
		}
		public function demonLabProjectEncounters():void {
			clearOutput();
			var choices:Array = [];
			if (time.hours <= 8 || time.hours >= 18) choices.push(0);
			choices.push(1);
			choices.push(2);
			if (!KihaFollower.FlameSpreaderBossKilled && KihaFollower.FlameSpreaderKillCount >= 20 && InCollection("Kiha", flags[kFLAGS.PLAYER_COMPANION_0], flags[kFLAGS.PLAYER_COMPANION_1], flags[kFLAGS.PLAYER_COMPANION_2] ,flags[kFLAGS.PLAYER_COMPANION_3]))
					choices.push(3);
			var select:int = rand(choices.length)
			switch (choices[select]) {
				case 0:
					nightwalkerEncounter();
					break;
				case 1:
					flamespreaderEncounter();
					break;
				case 2:
					tyrantEncounter();
					break;
				case 3:
					ultimisEcounter();
					break;
			}

			function nightwalkerEncounter():void {
				outputText("You find yourself feeling somewhat nervous. Your [skin] crawls, but as you wheel about, you see nothing. You hear nothing but a faint whisper on the wind.[pg]");
				outputText("“<i>Blood.</i>” A faint dripping sound comes from behind you. You turn, slowly, to face a corpse-pale woman in a crotchless skintight latex suit that leaves nothing to the imagination. Her eyes shine red, and her fangs stick out well beyond her lips. A spadelike tail flicks back and forth, dripping red, and she smiles, curved black horns and ebony tresses combining to make her seem...well, you assume the intent was to make her beautiful, but unlike the succubi, there’s almost no sex appeal in those eyes, no carnal desire as she glances between your legs, scraping one of her fingernails along her swollen pussy lips, cutting herself and drawing a trickle of blood.[pg]");
				outputText("“<i>Sweet blood, come... Sate yourself.</i>” Her nails are like black claws, but as she licks the blood off her fingers, part of you recoils in fear. “<i>Sate you...Then you’ll sate...me.</i>” You draw your [weapon], bracing yourself, but as you do, this gets only a smile as the curvy, short woman tilts her head. She launches herself toward you, claws outstretched, the eerie grin still on her face.[pg]");
				outputText("“<i>Blood! Blood for me!</i>”");
				outputText("[pg]“<b>You are now fighting Project Nightwalker.</b>”");
				startCombat(new ProjectNightwalker());
			}
			function flamespreaderEncounter():void {
				outputText("Hearing the flapping of leathery wings, you look skyward. A reddish figure is already swooping down towards you, and you throw yourself backwards. A massive spear barely misses your head, and a cloud of dust is thrown up by the impact. You draw your [weapon], the dust settling, and you finally get a glimpse of your attacker.[pg]");
				outputText("Your attacker has dusky brown skin, red scales from calf to neck, and slender curves. You look at her face, with draconic fangs, demonic horns and reptilian eyes. Flames jet from her nose with every breath, and she shifts her weight from side to side. She’s an odd mix of dragon and demon, with wide, womanly hips. She plants her spear, wings flapping.[pg]");
				outputText("You ready yourself for battle, and you hear the cracking of bones as the creature almost violently twists its own neck one way, then the other, laughing as it takes off, flying towards you with malice in its gaze.");
				outputText("[pg]“<b>You are now fighting Project Flamespreader.</b>”");
				startCombat(new ProjectFlameSpreader());
			}
			function tyrantEncounter():void {
				outputText("Your wanderings bring you in front of a massive form vaguely resembling a Drider. Easily seventeen feet tall and thirty feet long, the creature turns to face you, six crimson eyes gleaming. It wears blackened full plate armor thicker than any you’ve ever seen, with glistening spikes on its shoulders. Twin horns poke through the creature’s helmet. Those, and the eyes, are the only part of its body not covered in metal. It breathes heavily, and as it takes a step, the spikes on its legs sink a half-inch into the ground below. Corruption oozes from this creature in a sickening aura. It holds a massive halberd in each meaty fist, using them like axes.");
				outputText("[pg]On the creature’s back sits a heavily muscled Incubus, armored lightly, and holding an odd crossbow in one hand. He looks at you, smirking, and points.");
				outputText("[pg]“<i>Tyrant? Kill!</i>”");
				outputText("[pg]“<b>You are now fighting Project Tyrant.</b>”");
				startCombat(new ProjectTyrant());
			}
			function ultimisEcounter():void {
				outputText("You and your dragoness lover travel through [place], stopping for a moment. The air smells vaguely of sulphur...and it’s getting stronger. Casting your gaze skyward, you see a massive form, bright red, flying low to the ground...and heading right towards you. You barely have any time at all to react, but you manage to leap to the side, narrowly dodging a veritable pillar of flame. Kiha roars her rage, taking to the sky, but as she does, no less than five Flamespreaders fly in, forcing her to evade their deadly spears. Kiha looks back at you for a moment, before banking away, taking all five of the fakers with her.");
				if (silly()) outputText("[pg]Having seen plenty of Kiha’s ass, child-bearing hips and bountiful breasts, you conclude that they’re not even good enough to be Kiha’s fakes! You just hope she doesn’t eat those words.");
				outputText("[pg]“<b>You are now fighting the Ultimis Flamespreader.</b>”");
				startCombat(new UltimisFlamespreader());
			}
		}

		//Try to find a new location - called from doExplore once the first location is found
		public function tryDiscover():void
		{
			if (player.level > 0 && EvangelineFollower.EvangelineAffectionMeter < 1 && rand(2) == 0) {
				SceneLib.evangelineFollower.enterTheEvangeline();
				return;
			}
			if (player.level > 0 && (EvangelineFollower.EvangelineAffectionMeter == 1 || EvangelineFollower.EvangelineAffectionMeter == 2) && player.statusEffectv1(StatusEffects.TelAdre) >= 1 && flags[kFLAGS.HEXINDAO_UNLOCKED] >= 1 && rand(2) == 0) {
				SceneLib.evangelineFollower.alternativEvangelineRecruit();
				return;
			}
			if (player.level > 2 && player.hasKeyItem("Sky Poison Pearl") < 0 && flags[kFLAGS.SKY_POISON_PEARL] < 1 && rand(5) == 0) {
				pearldiscovery();
				return;
			}
			if (player.level > 5 && flags[kFLAGS.HIDDEN_CAVE_FOUND] < 1 && rand(10) == 0) {
				hiddencavediscovery();
				return;
			}
			if (flags[kFLAGS.FACTORY_SHUTDOWN] > 0 && TrollVillage.ZenjiVillageStage == 0 && rand(5) == 0) {
				SceneLib.trollVillage.FirstEncountersoftheTrollKind();
				return;
			}
			if (player.level >= 9 && player.hasKeyItem("Pocket Watch") < 0 && !player.hasStatusEffect(StatusEffects.PocketWatch) && rand(3) == 0) {
				pocketwatchdiscovery();
				return;
			}
			if (player.level >= 9 && player.hasKeyItem("Pocket Watch") < 0 && player.superPerkPoints > 0 && rand(5) == 0) {
				pocketwatchdiscovery();
				return;
			}
/*			if (player.level > 5 && flags[kFLAGS.RYUBI_LVL_UP] < 1 && rand(4) == 0) {
				ryubifirstenc();
				return;
			}
			if (player.level > 5 && flags[kFLAGS.RYUBI_LVL_UP] >= 1 && rand(4) == 0) {
				ryubirepenc();
				return;
			}
*/			if (flags[kFLAGS.PC_PROMISED_HEL_MONOGAMY_FUCKS] == 1 && flags[kFLAGS.HEL_RAPED_TODAY] == 0 && rand(5) == 0 && player.gender > 0 && !SceneLib.helFollower.followerHel()) {
				SceneLib.helScene.helSexualAmbush();
				return;
			}
			if (flags[kFLAGS.ALVINA_FOLLOWER] < 1 && rand(4) == 0) {
				SceneLib.alvinaFollower.alvinaFirstEncounter();
				return;
			}
			if (flags[kFLAGS.HEXINDAO_UNLOCKED] < 1 && rand(4) == 0) {
				clearOutput();
				outputText("Against your better judgment, curiosity gets the better of you, and you find yourself walking into a strange area.");
				outputText("\n\nNot long into your journey, you see a hooded figure looming across the landscape, moving at the same speed as it goes across the terrain. The odd creature captures your interest, and you start to follow it. You glance around, there's still no one else nearby, so you continue to tail the mysterious being.");
				outputText("\n\nHalf an hour or so later, still following the cloaked figure, you begin to hear the sound of running water. Moving on, you eventually come across the source: a decently sized river flows across the land, populated by variously sized islands. Stopping for a second to take a look around, the hooded person seems to be moving towards one of the several islands. He? She? It is still oblivious to your presence.");
				outputText("\n\nA voice rings from behind you, \"<i>Come to visit He'Xin'Dao, stranger?</i>\"");
				outputText("\n\nTurning around, you see a few hooded figures similar to the one you have been following. You curse at the thought that someone could've ambushed you so easily without you noticing them sooner. You state that you've been exploring and found this place. The figure peers at you through the veiled hood.\n\n"
					+ "\"<i>You seem lacking in soulforce, but luckily your soul is enough intact to allow future cultivation. So, since you are already here, what do you think about visiting our village? Maybe you would come more often to it in the future?</i>\"");
				outputText("\n\nYou ponder for a moment over the offer. The hooded beings don't seem to carry any malice, given they haven't attacked you nor attempted rape. Perhaps it would be of interest to explore this place?  You decide to accept their offer as they lead you over the wide bridge to one of the islands.  Several heavily armored guards peer at you searchingly, to which one of your new companions state that you are a new guest.  The guard gives a stoic nod as they step aside, no longer barring you from entry.  Your hooded friends guide you to a small island to properly register you as a guest. They give you a small guide on a piece of parchment, telling you places of interest and instructions on how to find this place again.");
				outputText("\n\nAfterwards, you're left alone.  You wander around, checking a few places of interest before you decide it's time to return to your camp.  With the guide in your hands, you're sure you'll find this place again with ease if you need to.");
				outputText("\n\n\n<b>You have unlocked He'Xin'Dao in Places menu!</b>");
				flags[kFLAGS.HEXINDAO_UNLOCKED] = 1;
				doNext(camp.returnToCampUseTwoHours);
				return;
			}
			if (player.explored > 1) {
				clearOutput();
				if (player.exploredForest <= 0) {
					outputText("You walk for quite some time, roaming the hard-packed and pink-tinged earth of the demon-realm.  Rust-red rocks speckle the wasteland, as barren and lifeless as anywhere else you've been.  A cool breeze suddenly brushes against your face, as if gracing you with its presence.  You turn towards it and are confronted by the lush foliage of a very old-looking forest.  You smile as the plants look fairly familiar and non-threatening.  Unbidden, you remember your decision to test the properties of this place, and think of your campsite as you walk forward.  Reality seems to shift and blur, making you dizzy, but after a few minutes you're back, and sure you'll be able to return to the forest with similar speed.\n\n<b>You've discovered the Forest!</b>");
					player.exploredForest = 1;
					player.exploredForest++;
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				if (player.exploredLake <= 0 && flags[kFLAGS.ALVINA_FOLLOWER] == 1) {
					outputText("Your wanderings take you far and wide across the barren wasteland that surrounds the portal, until the smell of humidity and fresh water alerts you to the nearby lake.  With a few quick strides, you find a lake so massive that the distant shore cannot be seen.  Grass and a few sparse trees grow all around it.\n\n<b>You've discovered the Lake!</b>");
					player.exploredLake = 1;
					player.explored++;
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				if (player.exploredLake >= 1 && rand(3) == 0 && player.exploredDesert <= 0) {
					outputText("You stumble as the ground shifts a bit underneath you.  Groaning in frustration, you straighten up and discover the rough feeling of sand ");
					if (player.lowerBody == LowerBody.HOOFED) outputText("in your hooves");
					else if (player.lowerBody == LowerBody.DOG) outputText("in your paws");
					else if (player.isNaga()) outputText("in your scales");
					else outputText("inside your footwear, between your toes");
					outputText(".\n\n<b>You've discovered the Desert (Outer)!</b>");
					player.exploredDesert = 1;
					player.explored++;
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				//Discover Battlefield Boundary
				if (player.exploredDesert >= 1 && flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] <= 0 && (player.level + combat.playerLevelAdjustment()) >= 5) {
					flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] = 1;
					player.explored++;
					clearOutput();
					outputText("While exploring you run into the sight of endless field, littered with the remains of fallen soldiers from what appears to have been the demon war, this much do the horned skeletons tells. You can see some golem husk on the ground as well. It’s very plausible the war is still ongoing.\n\n<b>You've discovered the Battlefield (Boundary)!</b>");
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				if (flags[kFLAGS.DISCOVERED_BATTLEFIELD_BOUNDARY] > 0 && flags[kFLAGS.DISCOVERED_HILLS] <= 0 && (player.level + combat.playerLevelAdjustment()) >= 5) {
					flags[kFLAGS.DISCOVERED_HILLS] = 1;
					player.explored++;
					clearOutput();
					outputText("As you walk the large open wasteland of mareth you begin to notice an elevation in the ground. Far in the distance you can see a mountain chain but from where you stand is a hillside. Well you got tired of the monotony of the flat land anyway maybe going up will yield new interesting discoveries.\n\n<b>You found the Hills!</b>");
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				if (flags[kFLAGS.DISCOVERED_HILLS] > 0 && flags[kFLAGS.TIMES_EXPLORED_PLAINS] <= 0 && (player.level + combat.playerLevelAdjustment()) >= 9) {
					flags[kFLAGS.TIMES_EXPLORED_PLAINS] = 1;
					player.explored++;
					outputText("You find yourself standing in knee-high grass, surrounded by flat plains on all sides.  Though the mountain, forest, and lake are all visible from here, they seem quite distant.\n\n<b>You've discovered the plains!</b>");
					doNext(camp.returnToCampUseOneHour);
					return;
				}
				//EXPLOOOOOOORE
				if (flags[kFLAGS.TIMES_EXPLORED_SWAMP] <= 0 && flags[kFLAGS.TIMES_EXPLORED_PLAINS] > 0 && (player.level + combat.playerLevelAdjustment()) >= 13) {
					flags[kFLAGS.TIMES_EXPLORED_SWAMP] = 1;
					player.explored++;
					clearOutput();
					outputText("All things considered, you decide you wouldn't mind a change of scenery.  Gathering up your belongings, you begin a journey into the wasteland.  The journey begins in high spirits, and you whistle a little traveling tune to pass the time.  After an hour of wandering, however, your wanderlust begins to whittle away.  Another half-hour ticks by.  Fed up with the fruitless exploration, you're nearly about to head back to camp when a faint light flits across your vision.  Startled, you whirl about to take in three luminous will-o'-the-wisps, swirling around each other whimsically.  As you watch, the three ghostly lights begin to move off, and though the thought of a trap crosses your mind, you decide to follow.\n\n");
					outputText("Before long, you start to detect traces of change in the environment.  The most immediate difference is the increasingly sweltering heat.  A few minutes pass, then the will-o'-the-wisps plunge into the boundaries of a dark, murky, stagnant swamp; after a steadying breath you follow them into the bog.  Once within, however, the gaseous balls float off in different directions, causing you to lose track of them.  You sigh resignedly and retrace your steps, satisfied with your discovery.  Further exploration can wait.  For now, your camp is waiting.\n\n");
					outputText("<b>You've discovered the Swamp!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}
				//Discover Blight Ridge
				if (flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] <= 0 && flags[kFLAGS.TIMES_EXPLORED_SWAMP] > 0 && (player.level + combat.playerLevelAdjustment()) >= 21) {
					flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] = 1;
					player.explored++;
					clearOutput();
					outputText("You wander around the mountain area thinking over this whole ‘demonic’ realm affair.  You're not sure how widespread this entire thing is, everything seems to be isolated to certain areas, you've only really seen the demons in small groups or alone, and even then it's usually comprised of imps.  As far as you know it IS a demonic realm so there should be some area where demons live normally, they can't all be hold up in lethice's stronghold right?  You question whether or not the demons could even hold together a city long enough before 'water' damage ruined the place.");
					if (flags[kFLAGS.BAZAAR_ENTERED] > 0) outputText("  Then again you have been to that Bizarre Bazaar, they seem to exist there to an extent without any trouble...");
					outputText("  As you think the random topic over in your head you spy a path you've never noticed before.\n\n");
					outputText("Being the adventurous champion you are you start down the path, as you walk down this sketchy path, carved through a section of the mountain a ridge comes into view.  Walking onwards until you're at the ridge a somewhat would-be beautiful sight lies before you.\n\n");
					if (player.cor < 66) {
						outputText("That would be if it wasn't corrupted to all hell, the scent of sweat, milk and semen invade your nose as you peer across the corrupted glade.  And you thought that the main forest was bad.");
						if (flags[kFLAGS.MET_MARAE] >= 1) outputText("  Gods... If Marae could see this.");
						outputText("\n\n");
					}
					else if (player.cor >= 66) {
						outputText("And it is!  Lush fields of corrupted glades consume the land, giving the heavy scent of sweat, milk and semen as you take a deep breath.  Taking it all in and relishing in the corruption.  Truly this is how the world should be.");
						if (flags[kFLAGS.MET_MARAE] >= 1) outputText("  Heh, if Marae could see this she'd flip her shit.");
						outputText("\n\n");
					}
					outputText("<b>You've discovered the Blight Ridge!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}
				//Discover Beach / Ocean / Deep Sea
				if (flags[kFLAGS.DISCOVERED_BEACH] <= 0 && flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] > 0 && (player.level + combat.playerLevelAdjustment()) >= 25) {
					flags[kFLAGS.DISCOVERED_BEACH] = 1;
					player.explored++;
					clearOutput();
					outputText("You hear seagulls in the distance and run on the grass to look what is beyond. There is a few dunes of sand with patch of grass that you eagerly cross over as you discover what you hoped to find.");
					outputText("\n\nFinally, after stepping over another dune, in the distance before you a shore of water spreads. Its surely way bigger than the lake you found some time ago. As far as you look to the side you can't see the shores end.  Mesmerized by the view you continue walking towards the ocean until you stand in the shallow water with waves passing by around your waist. Despite the corruption of Mareth this water turns out to be quite clear and who knows, maybe it’s not even that much tainted... yet. But that would probably require submerging deeper to check it out.");
					outputText("\n\n<b>You've discovered the Beach and the Ocean!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}
				//Discover Caves!
				if (flags[kFLAGS.DISCOVERED_CAVES] <= 0 && flags[kFLAGS.DISCOVERED_BEACH] > 0 && (player.level + combat.playerLevelAdjustment()) >= 30) {
					flags[kFLAGS.DISCOVERED_CAVES] = 1;
					player.explored++;
					clearOutput();
					outputText("As you explore the area you run into a somewhat big hole in the landscape. You look inside unsure as it seems to lead into the depths of Mareth. Resolving yourself to chase the demons wherever they go you decide to still enter the hole discovering a full world of linked tunnels beneath Mareth ground.\n\n");
					outputText("<b>You've discovered the Caves!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}/*
				//Discover Abyss
				if (flags[kFLAGS.DISCOVERED_BLIGHT_RIDGE] > 0 && flags[kFLAGS.] <= 0 && (player.level + combat.playerLevelAdjustment()) >= 10) {
					flags[kFLAGS.] = 1;
					player.explored++;
					clearOutput();
					outputText("You walk \n\n");
					outputText("<b>You've discovered the Abyss!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}
				//Discover Pit
				if (flags[kFLAGS.] > 0 && flags[kFLAGS.] <= 0 && ((rand(3) == 0 && player.level >= 16) || player.level >= 21)) {
					flags[kFLAGS.] = 1;
					player.explored++;
					clearOutput();
					outputText("You walk \n\n");
					outputText("<b>You've discovered the Pit!</b>");
					doNext(camp.returnToCampUseTwoHours);
					return;
				}
				*/
				//Used for chosing 'repeat' encounters.
				var choosey:Number = rand(5);
				//2 (gargoyle) is never chosen once cathedral is discovered.
				if(choosey == 2 && flags[kFLAGS.FOUND_CATHEDRAL] == 1)
				{
					choosey = rand(4);
					if(choosey >= 2) choosey++;
				}
				if (choosey == 3)
				{
					choosey = rand(4);
					if(choosey == 2) choosey += 2;
					if(choosey >= 3) choosey++;
				}
				//Chance of encountering Giacomo!
				if (choosey == 0) {
					player.explored++;
					if (flags[kFLAGS.SOUL_SENSE_GIACOMO] < 3 && rand(3) > 0) SceneLib.giacomoShop.giacomoEncounterSS();
					else if (flags[kFLAGS.DINAH_LVL_UP] < 1) SceneLib.dinahScene.DinahIntro1();
					else genericGolGobImpEncounters(true);
					return;
				}
				else if (choosey == 1) {
					player.explored++;
					if (flags[kFLAGS.LUMI_MET] == 0) SceneLib.lumi.lumiEncounter();
					else genericGolGobImpEncounters(true);
					return;
				}
				else if (choosey == 2) {
					player.explored++;
					if (flags[kFLAGS.GAR_NAME] == 0) SceneLib.gargoyle.gargoylesTheShowNowOnWBNetwork();
					else SceneLib.gargoyle.returnToCathedral();
					return;
				}
				//Monster - 50/50 imp/gob split.
				else {
					player.explored++;
					genericGolGobImpEncounters(true);
					return;
				}
			}
			player.explored++;
			doNext(camp.returnToCampUseOneHour);
		}

		//Temporaly place of finding enemies for lvl between 31 and 49
		public function tryDiscoverLL():void {
			clearOutput();
			if (rand(3) == 0) {
                if (silly()) {
                    outputText("You're walking in the woods\n\n");
                    outputText("There's no one around\n\n");
                    outputText("And your phone is dead\n\n");
                    outputText("Out of the corner of your eye you spot her\n\n");
                }
				outputText("<b>A Wasp Girl...</b>");
				startCombat(new WaspGirl());//lvl 33
				return;
			}
			else if (rand(2) == 0) {
				outputText("Traversing Mareth vast areas you're stopped by the arrow to the <u>kne</u> 'place between ground and your waist'.");
				outputText("\n\n<b>A wild Dark Elf Ranger Appears.</b>");
				startCombat(new DarkElfRanger());//lvl 39
				return;
			}
			else {
                if (silly()) {
                    outputText("You're walking in the woods\n\n");
                    outputText("There's no one around\n\n");
                    outputText("And your phone is dead\n\n");
                    outputText("Out of the corner of your eye you spot her\n\n");
                }
				outputText("<b>A Wasp Huntress...</b>");
				startCombat(new WapsHuntress());//lvl 48
				return;
			}
		}
		//Temporaly place of finding enemies for lvl between 51 and 69
		public function tryDiscoverML():void {
			clearOutput();
			if (rand(4) == 0) {
				outputText("Traversing Mareth vast areas you're stopped by the arrow to the <u>kne</u> 'place between ground and your waist'.");
				outputText("\n\n<b>A wild Dark Elf Sniper Appears.</b>");
				startCombat(new DarkElfSniper());//lvl 51
				return;
			}
			else if (rand(3) == 0) {
                if (silly()) {
                    outputText("You're walking in the woods\n\n");
                    outputText("There's no one around\n\n");
                    outputText("And your phone is dead\n\n");
                    outputText("Out of the corner of your eye you spot her\n\n");
                    outputText("<b>An Alraune Maiden...</b>");
                }
				startCombat(new AlrauneMaiden());//lvl 54
				return;
			}
			else if (rand(2) == 0) {
				outputText("Traversing Mareth vast areas you stops near something looking like a soul cultivator cave.");
				outputText("\n\n<b>A wild Kitsune Elder Appears.</b>");
				startCombat(new KitsuneElder());//lvl 55
				return;
			}
			else {
                if (silly()) {
                    outputText("You're walking in the woods\n\n");
                    outputText("There's no one around\n\n");
                    outputText("And your phone is dead\n\n");
                    outputText("Out of the corner of your eye you spot her\n\n");
                }
				outputText("<b>A Wasp Assassin...</b>");
				startCombat(new WaspAssassin());//lvl 63
				return;
			}
		}
		//Temporaly place of finding enemies for lvl between 70 and 94
		public function tryDiscoverHL():void {
			clearOutput();
			if (rand(2) == 0) {
				outputText("Traversing Mareth vast areas you're suddenly found yourself underwater!!!");
				outputText("\n\n<b>Aaaand....A wild Scylla Appears.</b>");
				player.underwaterCombatBoost();
				if (!player.canSwimUnderwater()) player.createStatusEffect(StatusEffects.UnderwaterOutOfAir,0,0,0,0);
				startCombat(new Scylla());//lvl 70
				return;
			}
			else {
				outputText("Traversing Mareth vast areas you stops near something looking like a soul cultivator cave.");
				outputText("\n\n<b>A wild Kitsune Sage Appears.</b>");
				startCombat(new KitsuneAncestor());//lvl 80
				return;
			}
		}
		//Temporaly place of finding enemies for lvl between 95 and 124
		public function tryDiscoverXHL():void {
			clearOutput();
			//if (rand(2) == 0) {
				outputText("Traversing Mareth vast areas you're suddenly found yourself underwater!!!");
				outputText("\n\n<b>Aaaand....A wild Kraken Appears.</b>");
				player.underwaterCombatBoost();
				if (!player.canSwimUnderwater()) player.createStatusEffect(StatusEffects.UnderwaterOutOfAir,0,0,0,0);
				startCombat(new Kraken());//lvl 100 GIGANT BOSS
				return;/*
			}
			else {
				outputText("Traversing Mareth vast areas you're suddenly found yourself underwater tangled in some sort of vines!!!");
				outputText("\n\n<b>Aaaand....A wild Seabed Alraune Appears.</b>");
				player.createStatusEffect(StatusEffects.HeroBane, 10, 0, 0, 0);
				player.underwaterCombatBoost();
				if (!player.canSwimUnderwater()) player.createStatusEffect(StatusEffects.UnderwaterOutOfAir,0,0,0,0);
				startCombat(new SeabedAlrauneBoss());//lvl 135 GIGANT PLANT BOSS
				return;
			}*/
		}
		//Temporaly place of finding enemies for lvl 125+
		public function tryDiscoverXXHL():void {
			clearOutput();
			//else {
				outputText("Traversing Mareth vast areas you're suddenly found yourself underwater tangled in some sort of vines!!!");
				outputText("\n\n<b>Aaaand....A wild Seabed Alraune Appears.</b>");
				player.createStatusEffect(StatusEffects.HeroBane, 10, 0, 0, 0);
				player.underwaterCombatBoost();
				if (!player.canSwimUnderwater()) player.createStatusEffect(StatusEffects.UnderwaterOutOfAir,0,0,0,0);
				startCombat(new SeabedAlrauneBoss());//lvl 135 GIGANT PLANT BOSS
				return;
			//}
		}

		public function tryRNGod():void {
			clearOutput();
			outputText("Traversing Mareth vast areas you're suddenly found yourself... somewhere!!! And looks like your prayers have been heard!!! (Even if you didn't pray at all!!!)");
			outputText("\n\n<b>Aaaand....A RNGod Appears.</b>");
			startCombat(new RNGod());
		}

		public function pearldiscovery():void {
			flags[kFLAGS.SKY_POISON_PEARL] = 1;
			clearOutput();
			outputText("While exploring, you feel something is off.  Wary of meeting new things in this world after your previous experiences, you decide to cautiously locate the source of this feeling.  Soon the object comes into view and you can see that it is an ordinary looking pearl.  Knowing that it may be more then it looks to be you check the suroundings next to it for a while before deciding to touch it.  Nothing happens so since it somehow attracted your attention you pocket this pearl.\n\n");
			inventory.takeItem(consumables.SPPEARL, camp.returnToCampUseOneHour);
		}

		public function hiddencavediscovery():void {
			flags[kFLAGS.HIDDEN_CAVE_FOUND] = 1;
			clearOutput();
			outputText("\nYou aproach what looks like a cave at first but the shattered bones on the ground hint to something else. Still where theres bones and dead explorer is bound to be treasure. The entrance is decorated with a pair of fiery torch");
			if (silly()) outputText(" and a sparkling arrow shaped sign post tell 'please come in adventurer, I'm in need of more bony decoration'");
			outputText(".\n\n");
			doNext(hiddencave.enterDungeon);
		}

		public function pocketwatchdiscovery():void {
			clearOutput();
			outputText("While exploring, you feel something is off.  Wary of finding new things in this world after your previous experiences, you decide to cautiously locate the source of this feeling.  Soon the object comes into view and you can see that it is an ordinary looking pocket watch.  Knowing that it may be more than it looks, you inspect the adjacent surroundings for a while before deciding to touch it. A faint voice echoes in your mind.\n\n \"<i>Only thou that shall sacrifice shall be rewarded.</i>\" \n\n");
			menu();
			addButtonIfTrue(6, "Sacrifice", pocketwatchdiscoveryYes, "Req. something 'super'.", player.superPerkPoints > 0);
			addButton(8, "Leave", pocketwatchdiscoveryNo);
		}
		private function pocketwatchdiscoveryYes():void {
			outputText("Determined you grab the watch. A feeling of pain pierces your soul making you momentarily black out. After returning to your senses, you see the watch is already hanging on your waist. A feeling of missing some piece of yourself nags at you but there doesn't appear to be anything missing at first glance. Well guess it won't kill you for now...	 you hope as you return to camp.\n\n");
			player.superPerkPoints--;
			player.createKeyItem("Pocket Watch", 0, 0, 0, 0);
			player.createStatusEffect(StatusEffects.MergedPerksCount, 0, 0, 0, 0);
			if (player.hasStatusEffect(StatusEffects.PocketWatch)) player.removeStatusEffect(StatusEffects.PocketWatch);
			doNext(camp.returnToCampUseOneHour);
		}
		private function pocketwatchdiscoveryNo():void {
			outputText("No you do not want to sacrifice anything. Leaving the watch behind, you return to the camp.\n\n");
			player.createStatusEffect(StatusEffects.PocketWatch, 0, 0, 0, 0);
			doNext(camp.returnToCampUseOneHour);
		}

		public function ryubifirstenc():void {
			flags[kFLAGS.RYUBI_LVL_UP] = 1;
			clearOutput();
			outputText("While exploring (rest is placeholder atm).\n\n");
			startCombat(new RyuBiDragon());
		}
		public function ryubirepenc():void {
			clearOutput();
			outputText("While exploring (rest is placeholder atm).\n\n");
			startCombat(new RyuBiDragon());
		}

		public function goSearchForPearls():void {
			clearOutput();
			outputText("You grab your [weapon] and goes on serching solution to your waning physical constitution.");
			if (player.hasPerk(PerkLib.ElementalConjurerSacrifice) && player.perkv1(PerkLib.ElementalConjurerSacrifice) < 2 && player.hasStatusEffect(StatusEffects.ElementalPearlGolems) && player.statusEffectv1(StatusEffects.ElementalPearlGolems) == 2) {
				player.addStatusValue(StatusEffects.ElementalPearlGolems, 1, 1);
				player.addPerkValue(PerkLib.ElementalConjurerSacrifice, 1, 1);
			}
			if (player.hasPerk(PerkLib.ElementalConjurerDedication) && player.perkv1(PerkLib.ElementalConjurerDedication) < 2 && player.hasStatusEffect(StatusEffects.ElementalPearlGolems)) {
				player.addStatusValue(StatusEffects.ElementalPearlGolems, 1, 1);
				player.addPerkValue(PerkLib.ElementalConjurerDedication, 1, 1);
			}
			if (player.hasPerk(PerkLib.ElementalConjurerResolve) && player.perkv1(PerkLib.ElementalConjurerResolve) < 2) {
				player.createStatusEffect(StatusEffects.ElementalPearlGolems, 1, 0, 0, 0);
				player.addPerkValue(PerkLib.ElementalConjurerResolve, 1, 1);
			}
			startCombat(new ElementalGolems());
		}
		public function elementalGolemBeaten1():void {
			clearOutput();
			outputText("You stops before beaten guardian quasi-gargoyle and reach toward it shoulder mounted shards yanking off each of them.\n\n");
			inventory.takeItem(useables.LELSHARD, elementalGolemBeaten1a);
		}
		private function elementalGolemBeaten1a():void {
			outputText("\n");
			player.addPerkValue(PerkLib.ElementalConjurerResolve, 1, 1);
			inventory.takeItem(useables.LELSHARD, cleanupAfterCombat);
		}
		public function elementalGolemBeaten2():void {
			clearOutput();
			outputText("You stops before beaten obsidian gargoyle and reach toward it shoulder mounted shards yanking off each of them.\n\n");
			inventory.takeItem(useables.LELSHARD, elementalGolemBeaten2a);
		}
		private function elementalGolemBeaten2a():void {
			outputText("\n");
			player.addPerkValue(PerkLib.ElementalConjurerDedication, 1, 1);
			inventory.takeItem(useables.LELSHARD, cleanupAfterCombat);
		}
		public function elementalGolemBeaten3():void {
			outputText("You stops before beaten living statue golem and reach toward it shoulder mounted crystals yanking off each of them.\n\n");
			inventory.takeItem(useables.ELCRYST, elementalGolemBeaten3a);
		}
		private function elementalGolemBeaten3a():void {
			outputText("\n");
			player.addPerkValue(PerkLib.ElementalConjurerSacrifice, 1, 1);
			inventory.takeItem(useables.ELCRYST, cleanupAfterCombat);
		}

		public function debugOptions():void
		{
			inventory.takeItem(consumables.W_FRUIT, playerMenu);
		}

		//Massive bodyparts scene
//[DESERT]
//[RANDOM SCENE IF CHARACTER HAS AT LEAST ONE COCK LARGER THAN THEIR HEIGHT,
//AND THE TOTAL COMBINED WIDTH OF ALL THEIR COCKS IS TWELVE INCHES OR GREATER]
		public function bigJunkDesertScene():void
		{
			clearOutput();
			var x:Number = player.longestCock();
			//PARAGRAPH 1
			outputText("Walking along the sandy dunes of the desert you find yourself increasingly impeded by the bulk of your " + cockDescript(x) + " dragging along the sandscape behind you.  The incredibly hot surface of the desert causes your loins to sweat heavily and fills them with relentless heat.");

			if (player.cocks.length == 1) outputText("  As it drags along the dunes, the sensation forces you to imagine the rough textured tongue of a monstrous animal sliding along the head of your " + Appearance.cockNoun(player.cocks[x].cockType) + ".");
			else if (player.cocks.length >= 2) outputText("  With all of your [cocks] dragging through the sands they begin feeling as if the rough textured tongues of " + num2Text(player.cockTotal()) + " different monstrous animals were slobbering over each one.");
			outputText("\n\n");

			//PARAGRAPH 2

			//FOR NON-CENTAURS]
			if (!player.isTaur()) {
				outputText("The impending erection can't seem to be stopped.  Your sexual frustration forces stiffness into your [cocks], which forces your torso to the ground.  Normally your erection would merely raise itself skyward but your genitals have grown too large and heavy for your " + hipDescript() + " to hold them aloft.  Instead you feel your body forcibly pivoting at the hips until your torso is compelled to rest face down on top of your obscene [cocks].");

				//IF CHARACTER HAS GIANT BREASTS ADD SENTENCE
				if (player.biggestTitSize() >= 35)  outputText("  Your " + Appearance.allBreastsDescript(player) + " hang lewdly off your torso to rest on the desert sands, seeming to bury the dunes on either side of you.  Their immense weight anchors your body, further preventing your torso from lifting itself up.  The burning heat of the desert teases your " + nippleDescript(0) + "s mercilessly as they grind in the sand.");
				//IF CHARACTER HAS A BALLS ADD SENTENCE
				if (player.hasBalls()) outputText("  Your " + player.bodyColor + sackDescript() + " rests beneath your raised [butt].  The fiery warmth of the desert caresses it, causing your [balls] to pulse with the need to release their sperm through your [cocks].");
				//IF CHARACTER HAS A VAGINA ADD SENTENCE
				if (player.vaginas.length >= 1) {
					outputText("  Your " + vaginaDescript() + " and " + clitDescript() + " are thoroughly squashed between the bulky flesh where your male genitals protrude from between your hips and the [butt] above.");
					//IF CHARACTER HAS A DROOLING PUSSY ADD SENTENCE
					if (player.vaginas[0].vaginalWetness >= VaginaClass.WETNESS_DROOLING) outputText("  Juices stream from your womanhood and begin pooling on the hot sand beneath you.  Wisps of steam rise up into the air only to tease your genitals further.  ");
				}
			}
			//FOR CENTAURS
			else {
				outputText("The impending erection can't seem to be stopped.  Your sexual frustration forces stiffness into your [cocks], which forces the barrel of your horse-like torso to the ground.  Normally your erection would merely hover above the ground in between your centaurian legs, but your genitals have grown too large and heavy for your " + hipDescript() + " to hold them aloft.  Instead, you feel your body being forcibly pulled down at your hindquarters until you rest atop your [cocks].");
				//IF CHARACTER HAS GIANT BREASTS ADD SENTENCE
				if (player.biggestTitSize() >= 35)  outputText("  Your " + Appearance.allBreastsDescript(player) + " pull your human torso forward until it also is forced to rest facedown, just like your horse half.  Your tits rest, pinned on the desert sand to either side of you.  Their immense weight anchors you, further preventing any part of your equine body from lifting itself up.  The burning heat of the desert teases your " + nippleDescript(0) + "s incessantly.");
				//IF CHARACTER HAS A BALLS ADD SENTENCE
				if (player.hasBalls()) outputText("  Your " + player.bodyColor + sackDescript() + " rests beneath your raised [butt].  The airy warmth of the desert teases it, causing your [balls] pulse with the need to release their sperm through your [cocks].");
				//IF CHARACTER HAS A VAGINA ADD SENTENCE
				if (player.vaginas.length >= 1) {
					outputText("  Your " + vaginaDescript() + " and " + clitDescript() + " are thoroughly squashed between the bulky flesh where your male genitals protrude from between your hips and the [butt] above.");
					//IF CHARACTER HAS A DROOLING PUSSY ADD SENTENCE
					if (player.vaginas[0].vaginalWetness >= VaginaClass.WETNESS_DROOLING) outputText("  The desert sun beats down on your body, its fiery heat inflaming the senses of your vaginal lips.  Juices stream from your womanhood and begin pooling on the hot sand beneath you.");
				}
			}
			outputText("\n\n");
			//PARAGRAPH 3
			outputText("You realize you are effectively trapped here by your own body.");
			//CORRUPTION BASED CHARACTER'S VIEW OF SITUATION
			if (player.cor < 33) outputText("  Panic slips into your heart as you realize that if any dangerous predator were to find you in this state, you'd be completely defenseless.  You must find a way to regain your mobility immediately!");
			else if (player.cor < 66) outputText("  You realize that if any dangerous predator were to find you in this state you'd be completely defenseless.  You must find a way to regain your mobility... yet there is a certain appeal to imagining how pleasurable it would be for a sexual predator to take advantage of your obscene body.");
			else outputText("  Your endowments have rendered you completely helpless should any predators find you.  Somewhere in your heart, you're exhilarated at the prospect.  The idea of being a helpless fucktoy for a wandering beast is unusually inviting to you.  Were it not for the thought that you might die of thirst in the desert, you'd be incredibly tempted to remain right where you are.");

			//SCENE END = IF CHARACTER HAS FULL WINGS ADD SENTENCE
			if (player.canFly()) outputText("  You extend your wings and flap as hard as you can, until at last you manage to lighten the bulk of your body somewhat - enough to allow yourself to drag your genitals across the hot sands and back to camp.  The ordeal takes nearly an hour.");
			//SCENE END IF CHARACTER HAS CENTAUR BODY
			else if (player.isTaur()) outputText("  You struggle and work your equine legs against the surface of the dune you are trapped on.  Your [feet] have consistent trouble finding footing, the soft sand failing to provide enough leverage to lift your bulk.  You breath in deeply and lean from side to side, trying to find some easier vertical leverage.  Eventually, with a crude crawl, your legs manage to push the bulk of your body onto more solid ground.  With great difficulty, you spend the next hour shuffling your genitals across the sandscape and back to camp.");
			//SCENE END = FOR ALL OTHER CHARACTERS
			else outputText("  You struggle and push with your [legs] as hard as you can, but it's no use.  You do the only thing you can and begin stroking your [cocks] with as much vigor as you can muster.  Eventually your body tenses and a light load of jizz erupts from your body, but the orgasm is truly mild compared to what you need.  You're simply too weary from struggling to give yourself the masturbation you truly need, but you continue to try.  Nearly an hour later " + sMultiCockDesc() + " softens enough to allow you to stand again, and you make your way back to camp, still dragging your genitals across the warm sand.");
			dynStats("lus", 25 + rand(player.cor / 5), "scale", false);
			fatigue(5);
			doNext(camp.returnToCampUseOneHour);
		}

	}
}