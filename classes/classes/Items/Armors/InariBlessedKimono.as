/**
 * ...
 * @author Liadri
 */
package classes.Items.Armors
{
import classes.Items.Armor;
import classes.Items.ItemTags;
import classes.PerkLib;
import classes.Player;
import classes.StatusEffects;

	public class InariBlessedKimono extends Armor {
		
		public function InariBlessedKimono()
		{
			super("I.B.Kimono","I.B.Kimono","Inari Blessed Kimono","a Inari Blessed Kimono",0,30,12000,"It is said that this beautiful Kimono decorated with flower motifs was worn by lady Inari, firstborn of Taoth who became the first leader of the kitsunes. Increase the potency of spells and soulskill by up to 50% based on purity and empower all Kitsunes ability. Like most kitsune outfit this Kimono is made to improve ones charms and thus leaves you as agile as if naked.","Light");
			withBuffs({
				'spellcost': -0.60,
				'teasedmg': +15
			});
			withPerk(PerkLib.InariBlessedKimono,0,0,0,0);
			withTag(ItemTags.A_REVEALING);
		}
		
		override public function canEquip(doOutput:Boolean):Boolean {
			if (game.player.level >= 40) return super.canEquip(doOutput);
			if (doOutput) outputText("You try and wear the legendary armor but to your disapointment the item simply refuse to stay on your body. It would seem you yet lack the power and right to wield this item.");
			return false;
		}
	}
}
