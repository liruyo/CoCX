/**
 * ...
 * @author Ormael
 */
package classes.Items.Weapons
{
import classes.Items.Weapon;
import classes.PerkLib;

public class AsteriusRage extends Weapon {
		
		public function AsteriusRage() {
			super("A.R", "A.R", "Asterius Rage", "Asterius Rage", "cleaves", 176, 20000, "This pair of massive axes once belonged to Asterius the god of the minotaurs.  It'd be hard for anyone smaller than a giant to wield effectively and as a mather of fact seems to work best in the hand of someone of truly titanic strength.  Those axes are double-bladed and deadly-looking.  Requires height of 6'6 or above\".", [WP_DUAL_MASSIVE,WP_MGWRATH].join(", "), WT_AXE);
		}
		
		override public function get attack():Number {
			var boost:int = 0;
			if (game.player.str >= 1000) boost += 24;
			if (game.player.str >= 900) boost += 22;
			if (game.player.str >= 800) boost += 20;
			if (game.player.str >= 700) boost += 18;
			if (game.player.str >= 600) boost += 16;
			if (game.player.str >= 500) boost += 14;
			if (game.player.str >= 400) boost += 12;
			if (game.player.str >= 300) boost += 10;
			if (game.player.str >= 225) boost += 8;
			if (game.player.str >= 150) boost += 6;
			if (game.player.str >= 75) boost += 4;
			boost += (game.player.cor) / 5;
			return (2 + boost);
		}
		
		override public function canEquip(doOutput:Boolean):Boolean {
			if (game.player.level >= 40){
				if (game.player.hasPerk(PerkLib.DualWield) && game.player.hasPerk(PerkLib.GigantGripSu) && game.player.playerHasFourArms()) return super.canEquip(doOutput);
				if (doOutput) {
					if (game.player.playerHasFourArms()) outputText("You aren't skilled enough to handle this pair of weapons!  Unless you want to hurt yourself instead of your enemies when trying to use them...  ");
					else outputText("You lack second pair of arms!  ");
				}
				return false;
			}
			else{
				if(doOutput) outputText("You try and wield the legendary weapon but to your disapointment the item simply refuse to stay in your hands. It would seem you yet lack the power and right to wield this item.");
				return false;
			}
		}
	}
}
