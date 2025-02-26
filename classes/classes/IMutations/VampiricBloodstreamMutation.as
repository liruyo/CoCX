/**
 * Original code by aimozg on 27.01.14.
 * Extended for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
import classes.PerkClass;
import classes.IMutationPerkType;
import classes.Creature;
import classes.Player;
import classes.Races;
import classes.StatusEffects;

public class VampiricBloodstreamMutation extends IMutationPerkType
    {
        private static const mName:String = "Vampiric Bloodstream";
        //v1 contains the mutation tier
        override public function mDesc(params:PerkClass, pTier:int = -1):String {
            var descS:String = "";
            pTier = (pTier == -1)? currentTier(this, player): pTier;
            if (pTier >= 1) descS += "Your bloodstream has started to adapt to the presence of vampiric blood";
            if (pTier >= 2){
                descS += " Vampire Thirst stack now decays every " + decay() + " days.";
            }
            descS += " Increases the maximum numbers of stacks of Vampire Thirst by " + vampStackC();
            if (pTier >= 3){
                descS += ", and increase their potency by " + potency() + "%";
            }
            if (descS != "")descS += ".";
            return descS;
			
            function vampStackC():int{
                if (pTier == 1) return 15;
                if (pTier == 2) return 45;
                if (pTier == 3) return 105;
                if (pTier == 4) return 225;
                return 0;
            }
			
			function decay():int{
				if (pTier == 2 || pTier == 3) return 2;
				if (pTier == 4) return 3;
				return 1;
			}
			
			function potency():int{
				if (pTier == 3) return 50;
				if (pTier == 4) return 100;
				return 0;
			}
        }

        //Name. Need it say more?
        override public function name(params:PerkClass=null):String {
            var sufval:String;
            switch (currentTier(this, player)){
                case 2:
                    sufval = "(Primitive)";
                    break;
                case 3:
                    sufval = "(Evolved)";
                    break;
                case 4:
                    sufval = "(Final Form)";
                    break;
                default:
                    sufval = "";
            }
            return mName + sufval;
        }

        //Mutation Requirements
        override public function pReqs(pCheck:int = -1):void{
            try{
                var pTier:int = (pCheck != -1 ? pCheck : currentTier(this, player));
                //This helps keep the requirements output clean.
                this.requirements = [];
                if (pTier == 0){
                    this.requireBloodsteamMutationSlot()
                    .requireCustomFunction(function (player:Player):Boolean {
                        return player.hasStatusEffect(StatusEffects.VampireThirst);
                    }, "Vampire Thirst")
                    .requireRace(Races.VAMPIRE);//potem dodać mosquito race i ew. inne co mogą wypijać krew
                }
                else{
                    var pLvl:int = pTier * 30;
                    this.requireLevel(pLvl);
                }
            }catch(e:Error){
                trace(e.getStackTrace());
            }
        }

        //Mutations Buffs
        override public function buffsForTier(pTier:int, target:Creature):Object {
            var pBuffs:Object = {};
            if (pTier == 1) pBuffs['lib.mult'] = 0.05;
            if (pTier == 2) pBuffs['lib.mult'] = 0.15;
            if (pTier == 3) pBuffs['lib.mult'] = 0.3;
            if (pTier == 4) pBuffs['lib.mult'] = 0.6;
            return pBuffs;
        }

        public function VampiricBloodstreamMutation() {
            super(mName + " IM", mName, SLOT_BLOODSTREAM, 4);
        }

    }
}
